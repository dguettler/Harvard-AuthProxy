require 'open3'
require 'cgi'

class PinSession

  cattr_accessor :home_dir, :passphrase, :app_id
  attr_accessor :user_id

  def initialize(attributes = {})
    @_attributes = attributes
  end

  def valid?
    return false unless first_name && last_name
    return false unless (user = Site::User.find_by_first_name_and_last_name(first_name, last_name))

    @user_id = user.id
    return true
  end

  protected
    def first_name
      decrypt unless decrypted?
      @_first_name
    end

    def last_name
      decrypt unless decrypted?
      @_last_name
    end

    def decrypt
      @_first_name, @_last_name = extract_message
      @_decrypted = true
    end

    def decrypted?
      !!@_decrypted
    end

    def extract_message
      encrypted_message = CGI.unescape(@_attributes['_azp_token'])
      decrypted_message = decrypt_message(encrypted_message)
      return if decrypted_message.blank?

      encoded_data, encoded_signature = decrypted_message.split('&')
      data      = CGI.unescape(encoded_data)
      signature = CGI.unescape(encoded_signature)

      # TODO: verify data against signature using azp public key

      authentication_data, attribute_data = data.split('&')
      return unless valid_authentication_data(authentication_data)

      attribute_data = Hash[attribute_data.split('|').collect { |el| el.split('=') }]
      return attribute_data['givenname'], attribute_data['sn']
    end

  private
    def decrypt_message(encrypted_message)
      Open3.popen3("/usr/bin/gpg --decrypt --homedir=#{PinSession.home_dir} --passphrase=#{PinSession.passphrase} --no-tty 2> /dev/null") do |stdin, stdout, error|
        stdin.write(encrypted_message)
        stdin.close
        stdout.read
      end
    end

    def valid_authentication_data(authentication_data)
      user_id, time_stamp, user_ip, app_id, id_type = authentication_data.split('|')

      # check for expired time_stamp
      return false if Time.parse(time_stamp).localtime + 120 < Time.now

      # check for invalid application ID
      return false if app_id != PinSession.app_id

      return true
    end
end
