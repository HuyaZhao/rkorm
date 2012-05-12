# encoding: utf-8

class Hash
  def symbolize_keys
    inject({}) do |hash, pair|
      hash[pair[0].to_sym] = pair[1]
      hash
    end
  end

  def except(*keys)
    dup.except!(*keys)
  end

  def except!(*keys)
    keys.each { |k| delete(k) }
    self
  end
end