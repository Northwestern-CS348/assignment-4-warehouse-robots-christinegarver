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
      :precondition (and (free ?r) (at ?r ?loc1) (no-pallette ?loc1) (no-robot ?loc2) (connected ?loc1 ?loc2) (connected ?loc2 ?loc1))
      :effect (and (at ?r ?loc2) (not (at ?r ?loc1)) (no-robot ?loc1) (not (no-robot ?loc2)))
   )
   (:action robotMoveWithPallette
      :parameters (?loc1 - location ?loc2 - location ?r - robot ?p - pallette)
      :precondition (and (at ?p ?loc1) (no-pallette ?loc2) (no-robot ?loc2) (connected ?loc1 ?loc2) (connected ?loc2 ?loc1))
      :effect (and (no-pallette ?loc1) (not (no-pallette ?loc2)) (no-robot ?loc1)
      (not (no-robot ?loc2)) (at ?r ?loc2) (at ?p ?loc2) (not (at ?p ?loc1)) (not (at ?r ?loc1)) (not (free ?r)))
   )
   (:action moveItemFromPalletteToShipment
      :parameters (?loc - location ?s - shipment ?sale - saleitem ?p - pallette ?o - order)
      :precondition (and (contains ?p ?sale) (packing-location ?loc) (at ?p ?loc) (ships ?s ?o) (not (complete ?s)))
      :effect (and (not (contains ?p ?sale)) (includes ?s ?sale))
   )
   (:action completeShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (started ?s) (not (complete ?s)) (ships ?s ?o))
      :effect (and (complete ?s) (available ?l))
   )

)
