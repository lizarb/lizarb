class DevSystem::HashRubyShell < DevSystem::RubyShell

  section :mergers

  def self.merge_reverse(hash, other_hash)
    hash.merge(other_hash) { |_key, oldval, _newval| oldval }
  end

  def self.merge_reverse!(hash, other_hash)
    hash.merge!(other_hash) { |_key, oldval, _newval| oldval }
  end

  section :transformers

  def self.transform_keys_recursively(hash, &block)
    return hash unless block_given?
    case hash
    when Hash
      hash.each_with_object({}) do |(key, value), result|
        result[yield(key)] = transform_keys_recursively(value, &block)
      end
    when Array
      hash.map { transform_keys_recursively(_1, &block) }
    else
      hash
    end
  end

  def self.transform_keys_recursively!(hash, &block)
    case hash
    when Hash
      hash.keys.each do |key|
        value = hash.delete(key)
        hash[yield(key)] = transform_keys_recursively!(value, &block)
      end
      hash
    when Array
      hash.map! { transform_keys_recursively!(_1, &block) }
    else
      hash
    end
  end

  section :symbolize

  def self.symbolize_keys(hash)
    hash.transform_keys(&:to_sym)
  end

  def self.symbolize_keys!(hash)
    hash.transform_keys!(&:to_sym)
  end

  def self.symbolize_keys_recursive(hash)
    transform_keys_recursively(hash, &:to_sym)
  end

  def self.symbolize_keys_recursive!(hash)
    transform_keys_recursively!(hash, &:to_sym)
  end

  section :stringify

  def self.stringify_keys(hash)
    hash.transform_keys(&:to_s)
  end

  def self.stringify_keys!(hash)
    hash.transform_keys!(&:to_s)
  end

  def self.stringify_keys_recursive(hash)
    transform_keys_recursively(hash, &:to_s)
  end

  def self.stringify_keys_recursive!(hash)
    transform_keys_recursively!(hash, &:to_s)
  end

end
