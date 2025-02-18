class CryptoSystem::DigestMd5GemShell < DevSystem::GemShell
  require "digest/md5"

  def self.digest_hex(menv)
    s = menv[:digest_hex_in] = menv[:digest_hex_in].to_s
    call(menv)

    ret = Digest::MD5.hexdigest(s)
    menv[:digest_hex_out] = ret

    log "digest_hex_in: #{s.size} bytes,  digest_hex_out: #{ret.size} bytes"
    menv
  end

end
