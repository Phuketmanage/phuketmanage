# frozen_string_literal: true

require "open3"
require "base64"
require "json"

class PdfRenderer
  DEFAULT_FORMAT = "A4"

  # html: required
  # header_html/footer_html: optional (for page numbers etc.)
  # returns: PDF bytes (String)
  def self.call(html:, header_html: nil, footer_html: nil, format: DEFAULT_FORMAT, landscape: false)
    payload = {
      html: html,
      header_html: header_html,
      footer_html: footer_html,
      format: format,
      landscape: landscape
    }

    node = ENV.fetch("NODE_BIN", "node")
    script_path = Rails.root.join("scripts", "render_pdf.mjs").to_s

    out, err, status = Open3.capture3(node, script_path, stdin_data: payload.to_json)

    Rails.logger.error("[PdfRenderer] node stderr:\n#{err}") if err.present?

    unless status.success?
      raise "PDF render error: #{err.presence || "unknown error"}"
    end

    pdf_bytes = Base64.decode64(out.to_s)

    raise "PDF render failed: empty output" if pdf_bytes.bytesize.zero?

    pdf_bytes
  end
end
