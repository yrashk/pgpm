# frozen_string_literal: true

class Pgmq < Pgpm::Package
  github "tembo-io/pgmq"

  def source
    Pathname(File.join(super, "pgmq-extension"))
  end

  def pgxn_meta_json_path
    File.join(source, "META.json.in")
  end

  def pgxn_meta_json
    @pgxn_meta_json ||= Oj.load(File.read(pgxn_meta_json_path).gsub(/@@VERSION@@/, version.to_s))
  end

  def source_url_directory_name
    "pgmq-#{version}/pgmq-extension"
  end
end
