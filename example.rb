xml = Language.new(:name => "XML")
mbus = Language.new(:name => "M-Bus")
tcp_ip = Language.new(:name => "TCP/IP")

ims = Actor.new(
  :name => "IMS", 
  :formats => [xml],
  :drops_message => 0.0,
  :distorts_message => 0.0,
  :is_available => 1.0
)

mbus2xml = LanguageTranslation.new(:from => mbus, :to => xml)
esi = Actor.new(
  :name => "ESI", 
  :formats => [xml, mbus], 
  :language_translations => [mbus2xml], 
  :known_addresses => [ims.identifier],
  :drops_message => 0.01,
  :distorts_message => 0.01,
  :is_available => 0.99
)

water_meter = Actor.new(
  :name => "Water meter", 
  :formats => [mbus], 
  :known_addresses => [esi.identifier],
  :drops_message => 0.01,
  :distorts_message => 0.01,
  :is_available => 0.99
)

thermometer = Actor.new(
  :name => "Termometer", 
  :formats => [mbus], 
  :known_addresses => [esi.identifier],
  :drops_message => 0.01,
  :distorts_message => 0.01,
  :is_available => 0.99
)

serial_bus = MessagePassingSystem.new(
  :name => "Serial bus", 
  :fixed => true,
  :actors => [esi, water_meter, thermometer],
  :drops_message => 0.001,
  :distorts_message => 0.001,
  :is_available => 1
)

network = MessagePassingSystem.new(
  :name => "Network", 
  :fixed => false,
  :actors => [ims, esi],
  :addressing_language => tcp_ip,
  :drops_message => 0.0,
  :distorts_message => 0.0,
  :is_available => 0.995
)

CommunicationNeed.new(:actors => [ims, water_meter, thermometer])

visualize ims, esi, water_meter, thermometer