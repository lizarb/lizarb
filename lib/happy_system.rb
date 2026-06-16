# frozen_string_literal: true

class HappySystem < Liza::System
  class Error < Error; end
  # Your code goes here...

  #

  color :coral

  has_subsystem :axo
  has_subsystem :linter
  
end