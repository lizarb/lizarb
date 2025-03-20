class CryptoSystem::DigestSha1GemShell < DevSystem::GemShell
  require "digest/sha1"

  def self.digest_hex(menv)
    s = menv[:digest_hex_in] = menv[:digest_hex_in].to_s
    call(menv)

    ret = Digest::SHA1.hexdigest(s)
    menv[:digest_hex_out] = ret

    log "digest_hex_in: #{s.size} bytes,  digest_hex_out: #{ret.size} bytes" if log? 4
    menv
  end

end
