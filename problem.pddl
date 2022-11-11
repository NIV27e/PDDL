(define (problem craftbot)
   (:domain craftbot)
   (:objects

         actor1  - actor
         node1 node2 node3 node4 node5 node6 node7 node8 node9 node10 - location
         red green blue black orange  - resource

        )
    (:init
        
        (actorstate actor1)
        (alocation actor1 node1)

        (resourcepresent red)
        (rlocation red node6)

        (resourcepresent blue)
        (rlocation blue node9)


        

        (connects node1 node2)
        (connects node2 node3)
        (connects node3 node4)
        (connects node4 node5)
        (connects node5 node6)
        (connects node6 node7)
        (connects node6 node8)
        (connects node7 node8)
        (connects node7 node9)
        (connects node8 node9)
        (connects node8 node10)

        ;Reverse
        (connects node10 node8)
        (connects node10 node9)
        (connects node9 node8)
        (connects node9 node7)
        (connects node8 node7)
        (connects node8 node6)
        (connects node7 node6)
        (connects node6 node5)
        (connects node5 node4)
        (connects node4 node3)
        (connects node3 node2)
        (connects node2 node1)
        
        (= (resource_count_in_loc  node4) 0)
        (=(resource_count_red node6 red) 4)
        (=(resource_count_red node9 blue) 5)

        
        

         
        )
    (:goal
      (and

          ;(buildinglocation  node4)
          ;(rlocation red node4)
          (construct_building node4 actor1)
           
       

       ))
)