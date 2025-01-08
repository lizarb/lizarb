class DevSystem::CoderayGemShell < DevSystem::GemShell

  # Liza lazily requires gems required in Controllers
  require "coderay"

  # Scans the given text with CodeRay for the specified language.
  #
  # @param text [String] the text to be scanned
  # @param lang [Symbol, String] the language of the text to be scanned
  # @return [CodeRay::Tokens] the scanned tokens
  def self.scan(text, lang)
    call({})
    log :higher, "Scanning #{text.length} bytes of #{lang} text with CodeRay..."
    CodeRay.scan(text, lang)
  end

  # Returns the lines of code (LOC) for the given text and language.
  #
  # @param text [String] the text to be analyzed
  # @param lang [Symbol, String] the language of the text to be analyzed
  # @return [Integer] the number of lines of code
  def self.loc(text, lang)
    scan(text, lang).loc
  end

  def self.loc_for(klass, lang = :ruby)
    fname = klass.source_location[0]
    fname = fname.sub "/version", "" if klass == Lizarb # this is a hack :)
    text  = TextShell.read(fname, log_level: :higher)
    loc(text, lang)
  end

end
