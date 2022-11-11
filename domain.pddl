;Header and description

(define (domain craftbot)

;remove requirements that are not needed
(:requirements :strips :equality :typing :conditional-effects :fluents :durative-actions :duration-inequalities :timed-initial-literals)

(:types 

 actor resource node person

;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
)

; un-comment following line if constants are needed
;(:constants )

(:predicates ;todo: define predicates here

(actorstate ?actor1 - actor)
(alocation ?actor1 - actor  ?node1 - location)
(connects ?nodea - location ?nodeb - location)
;(buildinglocation ?actor1 - actor ?node1 - location)
(buildinglocation ?node1 - location)

(construct_building ?node - location ?actor - actor)

(free ?actor - actor)

(mine ?resource - resource)

(building-start ?node - location)
(carry_resource ?resource - resource)

;;Whether resource with actor or not
(resourcepresent ?resource1 - resource)
(resourcemined ?resource1 - resource ?actor - actor)

;;
(actor_mine ?a - actor ?r - resource)


(foundation_laid ?node - location)




(resource_carry ?actor - actor ?resource - resource)


;;Resource location

(rlocation ?resource1 - resource ?node - location)

)


(:functions ;todo: define numeric functions here
(resource_count_in_loc  ?node - location)
(resource_count_in_mine ?node - location ?resource - resource)
(resource_count_red ?node -location ?resource - resource)


)

(:durative-action move

    :parameters (?actor - actor ?nodea - location ?nodeb - location)
    :duration (= ?duration 1)
    :condition (and 
        (over all (actorstate ?actor))
        (at start (alocation ?actor  ?nodea))
        (over all (connects ?nodea ?nodeb))
    )
    :effect (and 
        (at start (not (alocation ?actor  ?nodea)) )
        (at start (not (alocation ?actor  ?nodeb)) )
        (at end (alocation ?actor  ?nodeb))

        
    )

)

(:durative-action start-building
  :parameters (?actor - actor ?node - location )
  :duration (= ?duration 2)
  :condition (and 
    (over all (actorstate ?actor))
    (over all  (alocation ?actor ?node))
  )
  :effect (and 
    (at end (buildinglocation ?node))
    (at end (assign (resource_count_in_loc ?node)  0))

  )

)

(:durative-action mine
    :parameters (?node - location ?actor - actor ?resource - resource)
    :duration (= ?duration 3)
    :condition(and 
      (over all (actorstate ?actor))
      (over all  (alocation ?actor  ?node))
      (at start (rlocation ?resource ?node))
      ;(at start (=(resource_count_in_loc  ?node) 0))
      ;(at start(buildinglocation ?node))
    )
    :effect (and 
     (at start(buildinglocation ?node))
     (at start (not (resourcemined ?resource ?actor)))
     (at start (not (alocation ?actor  ?node)))
     (at start (not(resourcepresent ?resource)))
     (at end (resourcemined ?resource ?actor))
     (at end (carry_resource ?resource)) 
     (at end (assign (resource_count_in_mine ?node ?resource)(resource_count_red ?node  ?resource)))   
    )


)

(:durative-action pickup
    :parameters (?node - location ?actor - actor ?resource - resource)
    :duration (= ?duration 1)
    :condition(and
     (over all (carry_resource ?resource))
     (over all(alocation ?actor  ?node))
     (over all (actorstate ?actor))
     (at start (resourcemined ?resource ?actor))
     (at start (rlocation ?resource ?node))
     (at start (>=(resource_count_in_mine ?node ?resource)(resource_count_red ?node  ?resource)))
     (at start(buildinglocation ?node))
    )
    :effect(and
    (at start (resourcemined ?resource ?actor))
    (at end(resource_carry ?actor ?resource))
    (at end (decrease (resource_count_in_mine ?node ?resource) 1))
    
    )
)

(:durative-action deposit
    :parameters (?node - location ?actor - actor ?resource - resource)
    :duration (= ?duration 1)
    :condition (and 
         (over all (carry_resource ?resource))
        (over all (actorstate ?actor))
        (at start (alocation ?actor  ?node))
        (at start (resource_carry ?actor ?resource))
        (at start (>=(resource_count_in_loc  ?node) 0))
        (at start(buildinglocation ?node))
    )
    :effect (and 
        (at start (not(rlocation ?resource ?node)))
        (at start(not(alocation ?actor  ?node)))
        (at end (not(resource_carry ?actor ?resource)))
        (at end (rlocation ?resource ?node))
        (at end (alocation ?actor  ?node))
        (at end (increase (resource_count_in_loc  ?node) 1))
        
    )


)

(:durative-action construct
  :parameters (?node - location ?actor - actor )
  :duration (= ?duration 1)
  :condition (and 
   ;(over all (carry_resource ?resource))
    (over all (actorstate ?actor))
    (at start (>=(resource_count_in_loc  ?node) 2))
    (at start (alocation ?actor  ?node))
    (at start(buildinglocation ?node))
  )
  :effect (and 
    (at start(not(alocation ?actor  ?node)))
    (at end (alocation ?actor  ?node))
    (at end (assign (resource_count_in_loc  ?node) 0))
    (at end (construct_building  ?node ?actor))
    
  )
)



)