ims = Actor.new(:name => "IMS")

esi = Actor.new(:name => "ESI")

water_meter = Actor.new(:name => "Water meter")

CommunicationNeed.new(:subject => ims, :actors => [water_meter])

# DSL proposal:
# water_meter.sends(mbus) ->serial_bus-> eis
#
# water_meter.sends(mbus).through(serial_bus).to eis
# eis.sends(xml).through(tcp_ip_network).to ims
#
# ims.needs_to_communicate_with water_meter
# 