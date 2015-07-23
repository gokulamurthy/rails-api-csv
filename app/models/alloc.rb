require 'ipaddr'

class Alloc < DbBase
  has_columns :range, :ip, :device

  ALLOWED_IP_BLOCK = '1.2.0.0/16'

  validates :range, :ip, :device, presence: true
  validates :ip, format: IPAddr::RE_IPV4ADDRLIKE, allow_blank: true
  validates :device, format: /\Adevice\d+\z/i, allow_blank: true
  validate :ensure_ip_in_range, if: lambda { errors.empty? }
  validate :ensure_ip_uniqueness, if: lambda { errors.empty? }

  # custom reader method with default value
  def range
    @range || ALLOWED_IP_BLOCK
  end

  def self.find_by_ip(val)
    find(val, :ip)
  end

  private

  def ensure_ip_in_range
    addr = IPAddr.new(ALLOWED_IP_BLOCK)
    in_range = addr.include?(self.ip)
    self.errors.add(:ip, 'must be within the range') unless in_range
  end

  def ensure_ip_uniqueness
    ip_exists = self.class.find_by_ip(self.ip).present?
    self.errors.add(:ip, 'is already assigned') if ip_exists
  end
end
