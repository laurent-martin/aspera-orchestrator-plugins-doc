<!--
PANDOC_DEFAULTS_BEGIN
metadata:
  title: "Aspera Orchestrator Plugin Development Guide"
  author: "IBM Aspera"
PANDOC_DEFAULTS_END
-->

# Aspera Orchestrator Plugin Development Guide

## Introduction

This guide explains how to develop a plugin (action) for Aspera Orchestrator. Plugins allow you to extend Orchestrator's functionality by adding custom actions that can be used in workflows.

### What is a Plugin?

A plugin (also called an "action") is a Ruby class that extends Orchestrator's capabilities. Plugins can:

- Execute custom business logic
- Integrate with external systems (APIs, databases, file systems)
- Transform data and files
- Monitor events and trigger workflows
- Implement custom triggers that watch for specific conditions

### How Plugins are Detected and Loaded

Orchestrator automatically discovers and loads plugins through the following mechanism:

1. **Discovery**: Plugins are stored in the `actions/` directory (configurable via `actionplugins_load_directory`)
2. **Registration**: The system scans the actions directory and registers each plugin in the database
3. **Loading**: When enabled, the system loads the Ruby class files and executes any migration files
4. **Instantiation**: The `Action` module provides the base interface that all plugins must implement
5. **Execution**: When a workflow step runs, Orchestrator instantiates the plugin class and calls its `execute` method

The plugin system uses `ActiveRecord` for persistence, allowing plugins to store configuration in database tables that are automatically created via migration files.

## Plugin Structure

An Aspera Orchestrator plugin consists of several files organized in a dedicated directory:

```text
actions/my_plugin/
├── my_plugin.rb                    # Main plugin class (required)
├── metadata.yml                    # Metadata and version history (required)
├── edit.html.erb                   # Configuration UI (optional)
├── help.html.erb                   # Help documentation (optional)
├── MyPlugin.png                    # Plugin icon (optional, 48x48px recommended)
├── YYYYMMDDHHMMSS_*.rb            # Migration files (optional, for database schema)
├── my_plugin_controller.rb        # Controller for complex UI logic (optional)
├── my_plugin_helper.rb            # Helper methods for views (optional)
├── my_plugin_service.rb           # Service classes for business logic (optional)
└── additional_files/               # Additional support files (optional)
    ├── payloads/                   # XML/JSON templates
    ├── wsdl/                       # WSDL files for SOAP integrations
    └── sample_config/              # Configuration examples
```

### Additional Ruby Files

Based on analysis of 205 plugins:

- **Controllers** (~21 plugins): Used for complex UI interactions and AJAX operations
  - Example: `akamai_transcoding_controller.rb`
  - Handles form submissions, dynamic UI updates, and validation
  
- **Helpers** (~8 plugins): Provide view helper methods
  - Example: `ateme_transcoding_helper.rb`
  - Used for formatting data, generating UI elements
  
- **Services** (~5 plugins): Encapsulate business logic and external API calls
  - Example: `faspex5_package_monitor_authentication_service.rb`
  - Separate concerns and improve code organization

### File Naming Conventions

- **Main class file**: Must match the class name in snake_case (e.g., `HelloWorld` &rarr; `hello_world.rb`)
- **Migration files**: Format `YYYYMMDDHHMMSS_description.rb` (timestamp ensures execution order)
- **Icon file**: Must match the class name (e.g., `HelloWorld.png`)
- **View files**: `edit.html.erb` for configuration, `help.html.erb` for documentation

### Directory Location

Plugins are installed in the directory specified by `OrchConfig.actionplugins_load_directory`, which defaults to `config/orchestrator/actions`. During development, plugins are typically placed in the `actions/` directory at the `Rails` root.

## Plugin Architecture Patterns

After analyzing the core code and multiple plugins, the following patterns and mechanisms have been identified:

### Class Structure

All plugins must follow this structure:

```ruby
class MyPlugin < ActiveRecord::Base
  include Action
  
  # Constants for input/output variable names
  INPUT_PARAM = "input_param"
  OUTPUT_RESULT = "result"
  
  # Instance variables (inherited from Action module)
  # @inputs, @outputs, @status, @status_details, @percent_complete, @state_id
end
```

**Key Points:**

- Inherit from `ActiveRecord::Base` for database persistence
- Include the `Action` module which provides the plugin interface
- Define constants for all input/output variable names (improves maintainability)
- Use instance variables provided by the Action module

### Core Methods

Every plugin must implement these essential methods defined in the `Action` module:

#### Required Methods

- `self.version` - Returns plugin version as array [major, minor, release]
- `inputs_spec` - Returns two hashes: required_inputs and optional_inputs
- `outputs_spec` - Returns hash of output variables
- `category` - Returns array defining plugin category
- `execute` - Contains main execution logic

#### Optional Methods (for advanced features)

- `validate_inputs` - Custom input validation
- `synchronous_execution?` - Returns false for async execution
- `check_status` - Polls status for async operations
- `multiple_execution?` - Returns true for trigger-type plugins
- `pause`, `resume`, `cancel`, `rollback` - Lifecycle control
- `timeout` - Returns timeout in seconds (0 = no timeout, nil = default)
- `remote_execution?` - Returns false to prevent remote execution
- `recover` - Recovers from partial execution

### Execution Patterns

**Synchronous Execution** (default):

- `execute` method completes the work and returns final status
- Returns: `[status, status_details, outputs]`
- Example: Simple file operations, API calls, data transformations

**Asynchronous Execution** (for long-running operations):

- Override `synchronous_execution?` to return `false`
- `execute` starts the operation and returns `STATUS_INPROGRESS`
- Implement `check_status` to poll for completion
- Example: Transcoding jobs, large file transfers, batch processing

**Trigger Pattern** (for event-driven workflows):

- Set `synchronous_execution?` to `false`
- Set `multiple_execution?` to `true`
- Use `check_status` to detect events and return `STATUS_COMPLETE` when triggered
- Include the `ModuleTriggerTools` module for trigger persistence
- Example: File monitoring, package arrival detection, webhook listeners

## Required Elements

### Main Ruby Class

Each plugin must:

- Inherit from `ActiveRecord::Base`
- Include the `Action` module
- Define essential methods

### Required Methods

#### `self.version`

Returns the plugin version by reading from `metadata.yml`.

```ruby
def self.version
  return @@plugin_version_loaded if defined?(@@plugin_version_loaded)
  versions = SafeYaml.load_file("#{File.dirname(__FILE__)}/metadata.yml")[:revision_history].map { |change| change[:version].split(".").map { |num| num.to_i } }
  @@plugin_version_loaded = versions.sort_by { |major,minor,revision,patch| [major, minor, revision, (patch.nil? ? 0 : patch)] }.last
  return @@plugin_version_loaded
end
```

#### `self.display_name` (Optional but Recommended)

Customizes the display name in the UI. Used by ~100 plugins.

```ruby
def self.display_name
  return "My Custom Name"
end
```

**Note**: If not defined, the system generates a name from the class name (e.g., `MyPlugin` &rarr; "My plugin").

#### `name` (Optional)

Provides a human-readable identifier for a configured instance. Used by ~3 plugins for dynamic naming.

```ruby
def name
  if attributes["name"].present?
    return attributes["name"]
  end
  # Generate dynamic name based on configuration
  return "#{workflow.name} sub-workflow" if workflow
  return "#{self.class.name}_#{id}"
end
```

**Example**:  generates names based on the referenced workflow.

#### `inputs_spec`

Defines required and optional input parameters. This method is used for validation when saving a workflow.

```ruby
def inputs_spec
  required_inputs = { "param1" => TYPE_STRING }
  optional_inputs = { "param2" => TYPE_INT }
  return required_inputs, optional_inputs
end
```

**Available Input/Output Types:**

- `TYPE_STRING` - String value
- `TYPE_INT` - Integer value
- `TYPE_ARRAY` - Array value
- `TYPE_HASH` - Hash/dictionary value
- `TYPE_FLAG` - Boolean flag
- `TYPE_DATE` - Date value
- `TYPE_OBJECT` - Generic object
- `TYPE_PASSWORD` - Password (masked in UI)
- `TYPE_ATTACHMENT` - File attachment

#### `outputs_spec`

Defines output variables produced by the plugin. Sets the parameter name, type, and value to be output.

```ruby
def outputs_spec
  return { "result" => TYPE_STRING }
end
```

#### `category`

Defines the plugin's category in the UI. Available categories:

```ruby
def category
  return [CATEGORY_FILEOPERATIONS]
end
```

**Available Categories:**

- `CATEGORY_OTHER` - 'Other Utilities'
- `CATEGORY_SYSTEM` - 'System'
- `CATEGORY_TRIGGERS` - 'Triggers'
- `CATEGORY_FILEOPERATIONS` - 'File Operations'
- `CATEGORY_FILETRANSFORMATIONS` - 'File Transformations'
- `CATEGORY_FILETRANSFER` - 'File Transfer'
- `CATEGORY_USERINTERACTIONS` - 'User Interactions'
- `CATEGORY_INTEGRATION` - 'Integration'
- `CATEGORY_SCHEDULING` - 'Scheduling'
- `CATEGORY_TRANSCODING` - 'Transcoding'
- `CATEGORY_QUALITY_CONTROL` - 'Quality Control'

#### `execute`

Contains the main execution logic. This method must return three values:

```ruby
def execute
  @outputs = {}
  # Execution logic here
  @outputs["result"] = "value"
  return STATUS_COMPLETE, "Execution successful", @outputs
end
```

**Return Values:**

1. **@status** - Plugin execution status (see Status Constants below)
2. **@status_details** - String describing the current state (e.g., "Processing complete", "Error occurred")
3. **@outputs** - Hash containing output variables defined in `outputs_spec`

**Instance Variables:**

- `@inputs` - Hash of input values provided by the workflow engine
- `@outputs` - Hash of output values to return to the workflow engine

**Status Constants:**

- `STATUS_COMPLETE` - Execution completed successfully
- `STATUS_INPROGRESS` - Execution in progress (for asynchronous plugins)
- `STATUS_FAILED` - Execution failed
- `STATUS_ERROR` - Error occurred during execution
- `STATUS_PAUSED` - Execution paused
- `STATUS_PAUSING` - Execution is pausing
- `STATUS_CANCELING` - Execution is being canceled
- `STATUS_RESUMING` - Execution is resuming
- `STATUS_ROLLINGBACK` - Execution is rolling back
- `STATUS_INACTIVE` - Plugin is inactive
- `STATUS_ACTIVATING` - Plugin is activating
- `STATUS_OBSOLETE` - Plugin is obsolete
- `STATUS_UNDEFINED` - Status could not be determined
- `STATUS_TRUE` - Boolean true status
- `STATUS_FALSE` - Boolean false status

### metadata.yml File

The `metadata.yml` file contains plugin metadata:

```yaml
---
:revision_history:
  - :author: "Your Name"
    :change_description: Initial release
    :version: 1.0.0
    :date: "2024-01-01"
    :minimum_server_version: 4.1.0

:display_name: My Plugin
:category: File Operations
:help: "Description of what the plugin does"
:plugin_name: MyPlugin
:description: Short description of the plugin
```

## API Reference

This section provides reference information for constants and types used in plugin development.

### Data Types

Available data types for inputs/outputs:

- `TYPE_STRING` : String value
- `TYPE_INT` : Integer number
- `TYPE_FLOAT` : Float/Decimal number
- `TYPE_FLAG` : Boolean (true/false)
- `TYPE_HASH` : Hash/Dictionary structure
- `TYPE_ARRAY` : Array/List structure

### Execution Status

Possible statuses returned by `execute`:

- `STATUS_COMPLETE` : Successful execution
- `STATUS_FAILED` : Execution failed
- `STATUS_ERROR` : System error
- `STATUS_INPROGRESS` : In progress (for asynchronous execution)
- `STATUS_PAUSED` : Paused

### Categories

Available plugin categories:

- `CATEGORY_FILEOPERATIONS` : File Operations
- `CATEGORY_SYSTEM` : System
- `CATEGORY_INTEGRATION` : Integration
- `CATEGORY_OTHER` : Other Utilities

## Simple Example: "Hello World" Plugin

Here's a minimal plugin example that displays a personalized message:

### Directory Structure

```
actions/hello_world_simple/
├── hello_world_simple.rb
└── metadata.yml
```

### hello_world_simple.rb

```ruby
require 'yaml'

class HelloWorldSimple < ActiveRecord::Base
  include Action

  # Output variable name
  MESSAGE_OUTPUT = "message"
  
  # Input variable name
  NAME_INPUT = "name"

  # Version method - reads from metadata.yml
  def self.version
    return @@plugin_version_loaded if defined?(@@plugin_version_loaded)
    versions = SafeYaml.load_file("#{File.dirname(__FILE__)}/metadata.yml")[:revision_history].map { |change| change[:version].split(".").map { |num| num.to_i } }
    @@plugin_version_loaded = versions.sort_by { |major,minor,revision,patch| [major, minor, revision, (patch.nil? ? 0 : patch)] }.last
    return @@plugin_version_loaded
  end

  # Define inputs: one required parameter "name"
  def inputs_spec
    required_inputs = { NAME_INPUT => TYPE_STRING }
    optional_inputs = {}
    return required_inputs, optional_inputs
  end

  # Define outputs: one output "message"
  def outputs_spec
    return { MESSAGE_OUTPUT => TYPE_STRING }
  end

  # Plugin category
  def category
    return [CATEGORY_OTHER]
  end

  # Main execution method
  def execute
    begin
      # Initialize outputs
      @outputs = {}
      
      # Get the name from inputs
      name = @inputs[NAME_INPUT]
      
      # Create the message
      message = "Hello, #{name}!"
      
      # Set the output
      @outputs[MESSAGE_OUTPUT] = message
      
      # Return success status
      return STATUS_COMPLETE, "Message created successfully", @outputs
      
    rescue Exception => e
      # Handle errors
      return STATUS_ERROR, "Error: #{e.message}", {}
    end
  end
end
```

### metadata.yml

```yaml
---
:revision_history:
  - :author: "Developer"
    :change_description: Initial release
    :version: 1.0.0
    :date: "2024-01-01"
    :minimum_server_version: 4.1.0

:display_name: Hello World Simple
:category: Other Utilities
:help: "This plugin creates a personalized greeting message"
:plugin_name: HelloWorldSimple
:description: A simple plugin that demonstrates the basic structure of an Orchestrator action
```

### How It Works

1. **Input**: The plugin receives a `name` parameter
2. **Processing**: It creates a greeting message: "Hello, [name]!"
3. **Output**: Returns the message in the `message` output variable
4. **Status**: Returns `STATUS_COMPLETE` on success

## Testing Your Plugin

### Development vs Production Paths

- **Development path**: `/opt/aspera/orchestrator/actions` - Place plugins here during development
- **Production path**: `/opt/aspera/var/config/orchestrator/actions` - Plugins are loaded from here (configurable via `actionplugins_load_directory`)
- Database tables are updated when plugins are moved from development to production path

### Testing Steps

1. Place your plugin directory in the development `actions/` directory
2. Restart Orchestrator to load the plugin
3. The plugin will appear in the action list under the specified category
4. Create a workflow step using your plugin
5. Provide the required inputs
6. Execute and verify the outputs

### Important Notes

- **No empty classes**: Orchestrator will attempt to process empty classes and throw errors if they are present
- **JavaScript in views**: JavaScript code should be added directly to the `edit.html.erb` file, not in separate files
- **Database columns**: All plugins inherit standard columns from the `Action` base class (name, comments, etc.)

## Advanced Features

### Database Migrations

Plugins can create and modify database tables using migration files. This is essential for storing plugin configuration and state.

**Migration File Structure:**

```ruby
# File: 20240101120000_create_my_plugins.rb
class CreateMyPlugins < ActiveRecord::Migration[7.2]
  def change
    create_table :action_my_plugins do |t|
      t.string :name
      t.text :comments
      t.string :my_config_field
      t.timestamps
    end
  end
end
```

**Key Points:**

- Migration files must be prefixed with timestamp: `YYYYMMDDHHMMSS_description.rb`
- File must start with underscore: `_create_my_plugins.rb`
- File name must be plural and match the folder name (tableize is used to validate)
- Table name must follow pattern: `action_#{plugin_name.tableize}` (e.g., `action_my_plugins`)
- Migrations are executed automatically when plugin is loaded
- Use standard `Rails` migration methods: `create_table`, `add_column`, `change_column`, etc.
- Multiple migration files can exist in a plugin directory

**Versioning Migrations:**
When updating a plugin, create new migration files with later timestamps:

```ruby
# File: 20240201120000_my_plugins_add_new_field.rb
class MyPluginsAddNewField < ActiveRecord::Migration[7.2]
  def change
    add_column :action_my_plugins, :new_field, :string
  end
end
```

### Asynchronous Execution

For long-running operations that shouldn't block the workflow engine:

```ruby
def synchronous_execution?
  return false  # Indicates asynchronous execution
end

def execute
  # Start the operation (e.g., submit job to external system)
  @job_id = submit_job_to_external_system(@inputs)
  @status = STATUS_INPROGRESS
  return @status, "Job submitted: #{@job_id}", @outputs
end

def check_status
  # Poll external system for job status
  job_status = query_external_system(@job_id)
  
  if job_status == "complete"
    @outputs["result"] = get_job_result(@job_id)
    return STATUS_COMPLETE, "Job finished", @outputs
  elsif job_status == "failed"
    return STATUS_FAILED, "Job failed", @outputs
  else
    # Return polling interval (in seconds) as third parameter
    return STATUS_INPROGRESS, "Still processing", 30
  end
end
```

**Important Notes:**

- `synchronous_execution?` should return `false` to indicate asynchronous execution
- This prevents the action from blocking the Slave Queue Thread
- The third return value from `check_status` specifies the polling interval in seconds
- **Only use for triggers and long-running processes** - synchronous execution should be `true` for most plugins

### Trigger Plugins

Triggers watch for events and spawn new workflow instances. They use the trigger pattern:

```ruby
class MyTrigger < ActiveRecord::Base
  include Action
  include ModuleTriggerTools  # Provides trigger persistence methods
  
  def synchronous_execution?
    return false  # Triggers are always async
  end
  
  def multiple_execution?
    return (keep_ongoing == true) && (@is_canceled != true)
  end
  
  def execute
    @outputs = {}
    return nil, "Initializing trigger", nil
  end
  
  def check_status
    # Check for trigger condition
    if event_detected?
      @outputs["event_data"] = get_event_data
      
      # Persist trigger to avoid re-triggering
      register_triggers([event_identifier])
      persist_triggers(@current_triggers)
      
      return STATUS_COMPLETE, "Event detected", @outputs
    else
      return nil, "Waiting for event", polling_frequency
    end
  end
end
```

**Trigger Persistence:**

- Use `@current_triggers` to get previously triggered events
- Use `register_triggers([event_id])` to mark new events
- Use `persist_triggers(@current_triggers)` to save state
- Include `ModuleTriggerTools` module for trigger persistence methods

**Important Notes:**

- `synchronous_execution?` must return `false` for triggers
- `multiple_execution?` should return `true` to allow multiple workflow instances
- Triggers sit idle until an event occurs, so they shouldn't block the queue
- Use trigger persistence to avoid re-triggering on the same event

### Lifecycle Control (Pause/Resume/Cancel/Rollback)

Plugins can support workflow control operations:

```ruby
def pausable?
  return true  # Indicates pause is supported
end

def pause
  # Pause the operation
  @is_paused = true
  report_progress(STATUS_PAUSED, "Operation paused")
  return true
end

def resumable?
  return true
end

def resume
  # Resume the operation
  @is_paused = false
  return true
end

def cancelable?
  return true
end

def cancel
  # Cancel the operation
  cleanup_resources
  @status = STATUS_FAILED
  @status_details = "Operation canceled"
  return true
end

def rollbackable?
  return true
end

def rollback
  # Undo changes made by this plugin
  undo_changes
  return true
end
```

**Note:** By default, Orchestrator checks if these methods are overridden using `is_overloaded?`. See  for a complete implementation.

### Input Validation

Custom validation beyond type checking:

```ruby
def validate_inputs(inputs_hash = @inputs)
  # First perform default validation
  return false unless default_inputs_validation(inputs_hash)
  
  # Custom validation logic
  if inputs_hash["number"].present?
    return false if inputs_hash["number"].to_i < 0
  end
  
  if inputs_hash["email"].present?
    return false unless inputs_hash["email"].match?(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
  end
  
  return true
end
```

### Helper Methods

Common patterns for accessing configuration:

```ruby
# Get value from runtime inputs or fall back to database configuration
def default_get(field_name)
  var_name = field_name.upcase
  return @inputs[var_name] if @inputs && @inputs[var_name].present?
  return self.send(field_name) if self.respond_to?(field_name)
  return nil
end

# Example usage
def polling_frequency_get
  return default_get(:polling_frequency) || DEFAULT_POLLING_FREQUENCY
end
```

### Dynamic Input/Output Specifications

For plugins with variable inputs based on configuration:

```ruby
def inputs_spec
  required_inputs = {}
  optional_inputs = {}
  
  # Parse configuration to determine required inputs
  if command.present?
    Payload.variables(command).each do |var_name|
      required_inputs[var_name] = TYPE_STRING
    end
  end
  
  # Add standard optional inputs
  optional_inputs["timeout"] = TYPE_INT
  
  return required_inputs, optional_inputs
end
```

See  for an example using `eval` for maximum flexibility.

## Plugin Patterns Usage Statistics

Based on analysis of 205 plugins in the Orchestrator codebase:

### Common Patterns

| Pattern | Usage | Description |
|---------|-------|-------------|
| `SafeYaml` for version | 203/205 (99%) | Standard pattern for reading `metadata.yml` |
| `self.display_name` | 100/205 (49%) | Custom display names in UI |
| `MultiType` utilities | 88/205 (43%) | Type conversion and validation |
| Asynchronous execution | 80/205 (39%) | Long-running operations |
| `dependencies` method | 74/205 (36%) | External entity dependencies |
| `Payload` variables | 58/205 (28%) | Dynamic input extraction |
| `cancel` support | 58/205 (28%) | Cancellation capability |
| `timeout` definition | 54/205 (26%) | Custom timeout logic |
| `validate_inputs` | 40/205 (20%) | Custom validation |
| Trigger type | 37/205 (18%) | Event-driven workflows |
| `pause`/`resume` | 34/205 (17%) | Lifecycle control |
| `Gemfile` dependencies | 34/205 (17%) | External Ruby gems |
| `recover` method | 29/205 (14%) | Partial execution recovery |
| `remote_execution?` = false | 25/205 (12%) | Local-only execution |
| Controller files | 21/205 (10%) | Complex UI logic |
| Helper files | 8/205 (4%) | View helpers |
| Service files | 5/205 (2%) | Business logic separation |
| `rollback` support | 2/205 (1%) | Undo capability |

### Key Takeaways

1. **Version Management**: Nearly all plugins use the standard `SafeYaml` pattern for version reading
2. **Display Names**: Half of plugins customize their display name for better UX
3. **Type Handling**: `MultiType` is widely used for robust type conversion
4. **Async Operations**: 39% of plugins use asynchronous execution for long-running tasks
5. **Dependencies**: Over a third declare dependencies on other entities
6. **Advanced Features**: Pause/resume, cancel, and recover are used selectively where needed

## Best Practices

1. **Error Handling**: Always wrap execution logic in try/catch blocks
2. **Logging**: Use `Rails.logger` for debugging and error messages
3. **Constants**: Define constants for variable names and default values
4. **Documentation**: Provide clear help text and parameter descriptions
5. **Versioning**: Update `metadata.yml` with each change
6. **Testing**: Test with various input combinations
7. **Cleanup**: Clean up temporary files and resources
8. **Progress Reporting**: Use `report_progress` for long operations

## Advanced Usage Patterns

### Using Payload Variables

```ruby
def inputs_spec
  required_inputs = {}
  # Extract variables from a payload string
  Payload.variables(command).each do |var_name|
    required_inputs[var_name] = TYPE_STRING
  end
  return required_inputs, {}
end

def execute
  # Expand payload with actual values
  expanded_command = Payload.expand(command, @inputs, self)
  # ... use expanded_command ...
end
```

### Remote Node Integration

```ruby
def dependencies
  return [{ 
    entity: "RemoteNode", 
    id_key: "name", 
    id_value: remote_node, 
    dependent_field: "remote_node" 
  }]
end
```

### Multi-Type Conversion

```ruby
# Convert string to typed value
value = MultiType.convert_value(string_value, TYPE_INT)

# Convert value to string
string = MultiType.convert_to_string(value)

# Convert hash representation
hash = MultiType.convert_value_hash(string_hash)
```

## Plugin Development Alternatives and Possibilities

### Plugin Types and Use Cases

Orchestrator supports several types of plugins, each suited for different scenarios:

#### 1. **Standard Action Plugins**

- **Purpose**: Execute specific tasks within a workflow
- **Execution**: Synchronous or asynchronous
- **Examples**: File operations, API calls, data transformations
- **Best for**: One-time operations with clear inputs and outputs

#### 2. **Trigger Plugins**

- **Purpose**: Monitor for events and spawn new workflow instances
- **Execution**: Always asynchronous with `multiple_execution?` = true
- **Examples**: , file system monitors, message queue listeners
- **Best for**: Event-driven workflows, continuous monitoring
- **Key feature**: Include `ModuleTriggerTools` for trigger persistence

#### 3. **Integration Plugins**

- **Purpose**: Connect to external systems and services
- **Examples**: SOAP/REST APIs, databases, cloud services
- **Best for**: System integration, data exchange
- **Patterns**:
  - Use `Gemfile` for external dependencies (e.g., )
  - Store WSDL files for SOAP integrations (e.g., )
  - Use payload templates for complex requests (e.g., )

#### 4. **Custom Trigger with Code Evaluation**

- **Purpose**: Maximum flexibility for custom logic
- **Example**:
- **Features**: Allows users to define custom Ruby code for inputs, outputs, validation, and execution
- **Best for**: Power users who need complete control
- **Warning**: Security implications - only for trusted environments

### Configuration UI Options

Plugins can provide custom configuration interfaces:

#### 1. **Standard Form Fields**

Use Rails form helpers in :

```erb
<%= form_with model: @my_plugin, url: action_update_path(action_type: "my_plugin", id: @my_plugin.id) do |f| %>
  <li>
    <%= f.label :name %>
    <%= f.text_field :name %>
  </li>
  <li>
    <%= f.label :config_value %>
    <%= f.text_area :config_value %>
  </li>
<% end %>
```

#### 2. **Dynamic Configuration**

Display runtime-calculated values:

```erb
<% if @view == 'show' %>
  <li>
    <%= f.label 'Required Variables' %>
    <%= h Payload.variables(@my_plugin.command).join(', ') %>
  </li>
<% end %>
```

#### 3. **Help Documentation**

Provide detailed help in `help.html.erb` with HTML formatting, examples, and usage instructions.

### External Dependencies Management

#### Using Gemfile

For plugins requiring external Ruby gems:

```ruby
# File: actions/my_plugin/Gemfile
source 'https://rubygems.org'

gem 'aws-sdk-sqs', '~> 1.0'
gem 'rest-client', '~> 2.1'
```

Dependencies are automatically installed when the plugin is loaded.

#### System Dependencies

For external tools (e.g., ffmpeg, exiftool):

- Document in `metadata.yml` under `:external_dependencies`
- Check availability in plugin code
- Provide clear error messages if missing

### Plugin Versioning and Upgrades

#### Version Management

- Versions are defined in  `:revision_history`
- Format: `major.minor.release` (e.g., "1.2.3")
- Each version entry includes: author, change_description, version, date
- Optionally specify `minimum_server_version` and `maximum_server_version`

#### Upgrade Process

When upgrading a plugin:

1. Create new migration files with later timestamps
2. Update version in `metadata.yml`
3. The system automatically detects version changes
4. Migrations are executed in order
5. Old plugin instances are preserved for rollback

#### Deprecation

Mark plugins as deprecated:

```yaml
:revision_history:
  - :deprecation_orch_version: "4.2.0"
```

### Plugin Distribution

#### Packaging

Plugins can be packaged for distribution:

- Use the compact feature to create `.plugin` files
- Package includes all files: Ruby code, migrations, views, assets
- Format: Compressed tar archive with `.plugin` extension

#### Installation

- Upload via UI: Plugins &rarr; Upload
- API: POST to `/aspera/orchestrator/api/plugin_upload`
- Manual: Place in `actions/` directory and reload

#### Sharing

- Export plugin using compact feature
- Share `.plugin` file
- Recipients can import via UI or API

### Performance Considerations

#### Efficient Execution

- Use asynchronous execution for long-running operations
- Implement proper timeout values via `timeout` method
- Return appropriate polling intervals in `check_status`

#### Resource Management

- Clean up temporary files and connections
- Use `remote_execution?` = true to allow execution on remote nodes
- Implement proper error handling and recovery

#### Database Optimization

- Index frequently queried columns in migrations
- Use appropriate column types
- Avoid storing large data in database (use file system instead)

### Testing and Debugging

#### Development Workflow

1. Place plugin in `actions/` directory
2. Reload plugins via UI or API
3. Test in workflow designer
4. Check logs: `Rails.logger.info`, `Rails.logger.error`
5. Use Action Tester for isolated testing

#### Common Issues

- **Plugin not appearing**: Check `metadata.yml` syntax, verify file naming
- **Migration errors**: Ensure table name follows `action_*` pattern
- **Version conflicts**: Verify version comparison logic
- **Loading failures**: Check Ruby syntax, verify all required methods are implemented

### Security Considerations

#### Input Sanitization

- Always validate and sanitize user inputs
- Use parameterized queries for database operations
- Escape shell commands properly

#### Credential Management

- Never hardcode credentials
- Use Orchestrator's credential management
- Support environment variables for sensitive data

#### Code Execution

- Be cautious with `eval` (see )
- Validate file paths to prevent directory traversal
- Limit file system access to designated directories

## Conclusion

This comprehensive guide provides the foundation for developing Aspera Orchestrator plugins. Key takeaways:

1. **Start Simple**: Begin with the basic example and gradually add complexity
2. **Follow Patterns**: Study existing plugins in `actions/` for proven patterns
3. **Use the Framework**: Leverage the `Action` module and helper methods
4. **Test Thoroughly**: Use the Action Tester and test with various input combinations
5. **Document Well**: Provide clear `metadata.yml`, help files, and inline comments
6. **Consider Performance**: Use async execution and proper resource management
7. **Plan for Upgrades**: Use migrations for schema changes and version properly

For more examples and advanced techniques, explore the existing plugins in the `actions/` directory, particularly:

- Basic plugin with pause/resume/cancel
- Trigger pattern with persistence
- Dynamic code evaluation
- External gem dependencies

## Additional Resources

### Learning Ruby

For developers new to Ruby, these resources are recommended:

- [Ruby Tutorial - TutorialsPoint](http://www.tutorialspoint.com/ruby/) - Comprehensive Ruby tutorial
- [Codecademy Ruby Track](http://www.codecademy.com/tracks/ruby) - Interactive Ruby learning
- [Try Ruby](http://tryruby.org/levels/1/challenges/0) - Browser-based Ruby introduction
- [Ruby Monk](https://rubymonk.com/) - Interactive Ruby tutorials

### SOAP Integration (for SOAP-based plugins)

When working with SOAP web services:

```ruby
# Enable SOAP debugging to see request/response details
@driver = SOAP::WSDLDriverFactory.new(WSDL_URL).create_rpc_driver
@driver.wiredump_dev = STDOUT

# Get available methods from WSDL
available_methods = @driver.methods - Object.methods

# Get detailed information about input parameters
SOAP::Mapping.get_attributes()  # Shows what the WSDL requires
```

**WSDL Files:**

- Store WSDL files in the plugin directory (e.g., `actions/my_plugin/wsdl/service.wsdl`)
- Include XSD files for validation if provided
- Reference local WSDL files to avoid network dependencies

### Plugin Development Tips

1. **Folder Naming**: Plugin folder must be plural (e.g., `cerify_file_verifications`)
2. **Migration Naming**: Must start with underscore, be plural, and match folder name
3. **Controller Usage**: Add controllers for plugins requiring server-supplied data for the action template
   - Name: `{plugin_name}_controller.rb` (e.g., `cerify_file_verifications_controller.rb`)
4. **View Files**: All forms push data to the back-end from fields present in `edit.html.erb`
5. **Engine Variables**: The engine only sees `@inputs` and `@outputs` variables in the plugin
6. **Return Format**: All plugins must return `[@status, @status_details, @outputs]`
7. **Empty Classes**: No empty classes are allowed - Orchestrator will attempt to process them and throw errors
