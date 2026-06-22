# frozen_string_literal: true

require 'pathname'

# Module for converting HTML files to PDF using wkhtmltopdf
module PdfGenerator
  # Convert HTML file to PDF
  # @param html_file [String, Pathname] Path to input HTML file
  # @param pdf_file [String, Pathname] Path to output PDF file
  # @param options [Hash] Additional wkhtmltopdf options
  # @option options [String] :orientation Page orientation ('Portrait' or 'Landscape')
  # @option options [Boolean] :enable_local_file_access Enable local file access (default: true)
  def self.html_to_pdf(html_file:, pdf_file:, options: {})
    html_file = Pathname.new(html_file).expand_path
    pdf_file = Pathname.new(pdf_file).expand_path

    raise "HTML file not found: #{html_file}" unless html_file.exist?

    # Ensure output directory exists
    pdf_file.dirname.mkpath

    # Build wkhtmltopdf command
    cmd = ['wkhtmltopdf']

    # Add enable-local-file-access by default
    cmd << '--enable-local-file-access' if options.fetch(:enable_local_file_access, true)

    # Add orientation if specified
    cmd << '-O' << options[:orientation] if options[:orientation]

    # Add any additional options
    options.each do |key, value|
      next if %i[enable_local_file_access orientation].include?(key)

      cmd << "--#{key.to_s.tr('_', '-')}"
      cmd << value.to_s unless value == true
    end

    # Add input and output files
    cmd << "file://#{html_file}"
    cmd << pdf_file.to_s

    puts "Generating PDF: #{pdf_file}"
    system(*cmd) || raise("Failed to generate PDF: #{pdf_file}")
  end
end
