
@mbus = Language.new(name: "MBus")
@xml = Language.new(name: "XML")
@fi2xml = Language.new(name: "fi2xml")
@tcp_ip = Language.new(name: "TCP/IP")


@ims = Actor.new(name: "IMS", formats: [@xml, @fi2xml])

@internet = MessagePassingSystem.new(name: "Internet", is_available: 0.9995)

svk = Actor.new(name: "Production source system", is_available: 0.9995)
svk.sends(@xml).through(@internet).to @ims
@ims.needs_to_communicate_with svk, name: "Power consumption impact"
visualize svk

billing = Actor.new(name: "Power billing system", is_available: 0.9995)
billing.sends(@xml).through(@internet).to @ims
@ims.needs_to_communicate_with billing, name: "Price forecast"
visualize billing

heat_billing = Actor.new(name: "Heat billing system", is_available: 0.9995)
heat_billing.sends(@fi2xml).through(@internet).to @ims
@ims.needs_to_communicate_with heat_billing, name: "Heat consumption impact"
visualize heat_billing

heat_production = Actor.new(name: "Heat production source system", is_available: 0.9995)
heat_production.sends(@fi2xml).through(@internet).to @ims
@ims.needs_to_communicate_with heat_production, name: "Heat consumption impact"
visualize heat_production


recycling_system = Actor.new(name: "Recycling system", is_available: 0.9995)
recycling_system.sends(@xml).through(@internet).to @ims
@ims.needs_to_communicate_with recycling_system, name: "Waste impact"
@ims.needs_to_communicate_with recycling_system, name: "Transportation impact"
visualize recycling_system

transportation_system = Actor.new(name: "Transportation system", is_available: 0.9995)
transportation_system.sends(@xml).through(@internet).to @ims
@ims.needs_to_communicate_with transportation_system, name: "Transportation impact"
visualize transportation_system

active_house_system = Actor.new(name: "Active House system", is_available: 0.9995)
active_house_system.sends(@xml).through(@internet).to @ims
@ims.needs_to_communicate_with active_house_system, name: "CO2 Analysis"
visualize active_house_system

