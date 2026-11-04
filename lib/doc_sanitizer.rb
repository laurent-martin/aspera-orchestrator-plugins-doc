# frozen_string_literal: true

require 'ipaddr'

# Makes text written by plugin authors (help pages, field hints) safe to publish:
# its examples have real names and addresses, and values that secret scanners (Vault Radar) flag.
# Used by both generators: plugin manual (AsperaOrchestratorDocGenerator) and plugin specifications (ActionTemplateReference).
module DocSanitizer
  # A value that is a generic word, not an example password (scanners do not flag it): keeps syntax such as ftp://[username[:password]@host
  RE_PASSWORD_WORD = /(?:password|passwd|pwd|pass)\b/i
  # Example secrets: [regex, placeholder]
  # Placeholders must contain "_": that is how code_placeholders finds them
  # Words may be separated by non-breaking spaces, hence [[:space:]]
  SECRETS = [
    # PEM private key: full block on one line, or header followed by "..."
    [/-----BEGIN[[:space:]](?:[A-Z]+[[:space:]])*PRIVATE[[:space:]]KEY-----(?:.*?-----END[[:space:]](?:[A-Z]+[[:space:]])*PRIVATE[[:space:]]KEY-----|[[:space:]]*\.\.\.)?/, '<PEM_PRIVATE_KEY>'],
    # AWS access key ID
    [/\b(?:AKIA|ASIA)[0-9A-Z]{16}\b/, '<AWS_ACCESS_KEY_ID>'],
    # Slack token
    [/\bxox[abposr]-[0-9A-Za-z-]{10,}/, '<SLACK_TOKEN>'],
    # HTTP Authorization value: token has a digit or base64 padding, unlike words such as "Bearer token"
    [%r{\bBearer([[:space:]]+)(?=[^[:space:]"]*[0-9=])[A-Za-z0-9._~+/=-]{8,}}, 'Bearer\1<ACCESS_TOKEN>'],
    [%r{\bBasic([[:space:]]+)(?=[^[:space:]"]*[0-9=])[A-Za-z0-9+/=]{8,}}, 'Basic\1<BASE64_CREDENTIALS>'],
    # XML element with a secret value (an example payload): the placeholder is text, so that the XML stays well-formed
    # Not <%= ... %>, which would create an input in an Orchestrator payload
    [%r{<(Token|AccessToken|Secret)>(?![<$])[^<]+</\1>}, '<\1>${ACCESS_TOKEN}</\1>'],
    [%r{<(Password|Passphrase|KeyPassphrase)>(?![<$])[^<]+</\1>}, '<\1>${PASSWORD}</\1>'],
    # Password in a URL: user information, or query parameter (not a word that already says "password")
    [%r{\b([a-z][a-z0-9+.-]*://[^:/[:space:]@]+:)(?!<|#{RE_PASSWORD_WORD})[^@[:space:]/]+@}, '\1<YOUR_PASSWORD>@'],
    [/([?&](?:password|passwd|pwd)=)(?!<|#{RE_PASSWORD_WORD})[^&[:space:]`'")]+/i, '\1<YOUR_PASSWORD>'],
    # Password in a connection string: Pwd=...;
    [/\b((?:Pwd|Password)=)(?!<)[^;[:space:]]+(?=;)/i, '\1<YOUR_PASSWORD>']
  ].freeze
  # Names replaced one by one: the other names of these domains are real services
  NAMES = [
    [/\balex@ibm\.com\b/, 'alex@example.com'],
    [/\borchestrator@asperasoft\.com\b/, 'orchestrator@example.com'],
    [/\bcatdvserverone\.aspera\.com\b/, 'catdv.example.com'],
    [/\bquiet-waters-1228\.herokuapp\.com\b/, 'media.example.com'],
    [/\bmyproxy\.com\b/, 'proxy.example.com'],
    [/\bw\.demo\.aspera\.org\b/, 'demo.example.com'],
    [/\btest\.sl\.dev\.asperacloud\.net\b/, 'test.example.com'],
    [/\btestchris5\.aspera\.cloud\b/, 'aspera.example.com'],
    # Account at a real service: its domain is part of the syntax, so it stays. AoC organization, also found alone
    [/\bsedemo\b/, 'myorg'],
    [/\bpo21umhx(?=\.mediaconvert\.)/, 'abc123']
  ].freeze
  # Domains used as examples by plugin authors: with any host or user, they become example.com (RFC 2606)
  # A list, because other domains in this text are real services (api.github.com)
  EXAMPLE_DOMAINS = %w[
    ac.com azure-bus.com baton-server.com company.com corp.com domain.com enterprise.com
    fileserver.com lala.com mycompany.com server.com xxx.net
  ].freeze
  RE_EXAMPLE_DOMAIN = /(?<![\w-])#{Regexp.union(EXAMPLE_DOMAINS)}\b/
  RULES = [*SECRETS, *NAMES, [RE_EXAMPLE_DOMAIN, 'example.com']].freeze
  # Four numbers that may be an IPv4 address: not part of a longer dotted number, such as a version
  RE_DOTTED_QUAD = /(?<![\d.])\d{1,3}(?:\.\d{1,3}){3}(?!\.?\d)/
  # IPv4 ranges kept: not public (private, loopback, link-local, multicast...) or reserved for documentation (RFC 5737)
  KEPT_IP_RANGES = %w[
    0.0.0.0/8 10.0.0.0/8 127.0.0.0/8 169.254.0.0/16 172.16.0.0/12 192.168.0.0/16 224.0.0.0/3
    192.0.2.0/24 198.51.100.0/24 203.0.113.0/24
  ].map { |range| IPAddr.new(range) }.freeze
  # In Markdown: fenced code block, code span, or placeholder (only the last one is outside code, as the first two are matched first)
  RE_CODE_OR_PLACEHOLDER = /^[ \t]*(`{3,}).*?^[ \t]*\1`*[ \t]*$|(?<![\\`])(`+)(?!`)[^\n]*?(?<!`)\2(?!`)|<[A-Z0-9]+(?:_[A-Z0-9]+)+>/m

  class << self
    # @param text [String] Text written by a plugin author
    # @return [String] Same text, with placeholders and values reserved for examples
    def sanitize(text)
      return text unless text.is_a?(String)
      RULES
        .inject(text) { |result, (regex, replacement)| result.gsub(regex, replacement) }
        .gsub(RE_DOTTED_QUAD) { |ip| public_ip?(ip) ? "192.0.2.#{ip.split('.').last}" : ip }
    end

    # Outside code, the reader of the PDF toolchain (markdown_mmd) takes <A_B> as an HTML tag, and drops it
    # @param markdown [String] Sanitized Markdown
    # @return [String] Same Markdown, with placeholders in code
    def code_placeholders(markdown)
      markdown.gsub(RE_CODE_OR_PLACEHOLDER) { |match| match.start_with?('<') ? "`#{match}`" : match }
    end

    private

    def public_ip?(text)
      address = IPAddr.new(text)
      KEPT_IP_RANGES.none? { |range| range.include?(address) }
    rescue IPAddr::InvalidAddressError
      false
    end
  end
end
