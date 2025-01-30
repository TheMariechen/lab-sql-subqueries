use sakila;

### Write SQL queries to perform the following tasks using the Sakila database:

	# 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
    # Need: film, inventory 
    select count(inventory_id)    
    from inventory 
    where film_id in (select film_id
						from film
                        where title = "Hunchback Impossible"); # answer is 6 copies 
    
    # 2. List all films whose length is longer than the average length of all the films in the Sakila database.
    # Need: ONLY film 
    select film_id, length 
    from film
    where length > (select avg(length) from film);
    
    # 3. Use a subquery to display all actors who appear in the film "Alone Trip".
    # Need: actor, film 
    select first_name, last_name
    from actor
    where actor_id in (select actor_id 
						from film_actor
                        where film_id = (select film_id
											from film 
											where title = "Alone Trip")); 
    
### Bonus:
	# 4. Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.
    # 5. Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.
    # 6. Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.
    # 7. Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.
    # First step = find most profitable customer [need. customer and payment]
    
    select title
    from film 
    where film_id in (select film_id
						from inventory 
                        where inventory_id in (select inventory_id
												from rental 
                                                where customer_id = select customer_id, sum(amount)
																	from payment
																	group by customer_id
																	order by sum(amount)
																	limit 1))); 
    # start by writing child query (last part where we identify the top customer, then trace the route to film table through inventory table!)
    
    # 8. Retrieve the customer_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.
	# hint: need to find those that spent more than the average customer. so first calculate average per customer and use this result to identify those that are above 
    
    # 8a). sum per customer - total spent per client 
    select customer_id, sum(amount) as total_spent
    from payment
    group by customer_id;
    
    # 8b). now need to get average based on that - cool thing about subqueries is that you can fit them anywhere in the code (next to select, from, where etc.) 
    select avg(total_spent) as avtspc
    from (select customer_id, sum(amount) as total_spent # here child from above inserted 
    from payment
    group by customer_id) as ts;
    
    # 8c) 
    select customer_id, sum(amount) as tas
    from payment 
    group by customer_id # having because we need to filter on the already grouped data
    having tas > (select avg(total_spent) as avtspc
					from (select customer_id, sum(amount) as total_spent # here child from above inserted 
							from payment
							group by customer_id) as ts);
    
    
    
