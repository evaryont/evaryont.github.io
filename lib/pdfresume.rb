require 'pdfkit'

class PDFResume < Middleman::Extension
  #alias :included :registered

  def initialize(app, options_hash={}, &block)
    super

    input_file = 'build/resume.html'
    output_file = 'build/resume.pdf'

    app.after_build do |builder|
      begin
        kit = PDFKit.new(File.new(input_file),
                         print_media_type: true,
                         enable_local_file_access: true,
                         images: true,
                         enable_javascript: true,
                         dpi: 96)

        builder.say_status 'PDF Resume',  "Running #{kit.command(output_file)}..."
        file = kit.to_file(output_file)

      rescue Exception => e
        builder.say_status 'PDF Resume',  "Error: #{e.message}", Thor::Shell::Color::RED
        raise
      end
      builder.say_status 'PDF Resume',  "PDF file available at #{output_file}"
    end
  end

end

::Middleman::Extensions.register(:pdfresume, PDFResume)
