# seed data everytime while initializing the app.
# Will fail gracefully if the record is already seeded.
#
# Alloc.new(range: '1.2.0.0/16', ip: '1.2.3.4', device: 'device1').save
# Alloc.new(range: '1.2.0.0/16', ip: '1.2.3.5', device: 'device2').save
# Alloc.new(range: '1.2.0.0/16', ip: '1.2.3.6', device: 'device3').save
# Alloc.new(ip: '1.2.128.1', device: 'device1').save
# Alloc.new(ip: '1.2.128.2', device: 'device2').save
