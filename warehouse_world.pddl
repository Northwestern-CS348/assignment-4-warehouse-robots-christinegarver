(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   (:action robotMove
      :parameters (?loc1 - location ?loc2 - location ?r - robot)
      :precondition (and (no-robot ?loc2) (connected ?loc1 ?loc2) (connected ?loc2 ?loc1))
      :effect (and (at ?r ?loc2) (no-robot ?loc1))
   )
   (:action robotMoveWithPallette
      :parameters (?loc1 - location ?loc2 - location ?r - robot ?p - pallette)
      :precondition (and (has ?r ?p) (no-pallette ?loc2) (no-robot ?loc2))
      :effect (and (no-pallette ?loc1) (no-robot ?loc1) (at ?r ?loc2))
   )
   (:action moveItemFromPalletteToShipment
      :parameters (?loc - location ?s - shipment ?sale - saleitem ?p - pallette ?o - order)
      :precondition (and (contains ?p ?sale) (not (complete ?s)))
      :effect (and (ships ?s ?o) (includes ?s ?sale))
   )
   (:action completeShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (not (complete ?s)) (available ?l))
      :effect (and (ships ?s ?o) (complete ?s))
   )

)
