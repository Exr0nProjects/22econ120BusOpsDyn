println("compiled... executing")
using Distributions, Random
using Plots; gr();
using Match
using DataStructures
# using Base.Collections
using Formatting    # https://stackoverflow.com/a/37032242

SEED = 1338
# ROUNDS = Int(1e4)
CUSTOMERS = Int(4)

function simulate(n_customers)
    lambda_arrive, lambda_checko = 5, 10
# lambda_arrive, lambda_checko = 10, 10

    d = Exponential(lambda_arrive) # https://discourse.julialang.org/t/sampling-from-a-normal-distribution/36848

    Random.seed!(SEED)
    println("sampling...")
    samples_arrive = rand(Exponential(lambda_arrive), n_customers)  # delta T
    samples_checko = rand(Exponential(lambda_checko), n_customers)  # U_k

    println(round.(samples_arrive, digits=1))
    println(round.(samples_checko, digits=1))

    samples_arrive, samples_checko = floor.(samples_arrive), floor.(samples_checko)

    samples_arrive  = cumsum(samples_arrive)                        # T_k
    # wait_cumsum = zeros(n_customers + 1)
    # wait_cumsum[2:end] = cumsum(samples_checko)                     # leaving time

    
    # SHOPPING_TIME = 15;
    SHOPPING_TIME = 0;


    # state
    queue = []
    n_available_cashiers = 1

    events = PriorityQueue()
    for (i, t) in enumerate(samples_arrive)
        enqueue!(events, t, ("arrived", i))
    end 

    # metrics
    len_on_enter = zeros(Int, n_customers)
    wait_time_by_customer = zeros(n_customers)
    event_times_by_customer = zeros(n_customers, 4)     # events: 1 = arrive, 2 = queue, 3 = dequeue, 4 = done serving

    # event loop
    while length(events) > 0
        (t, (ev, id)) = dequeue_pair!(events)
        printfmtln("at time {:.2f}, {} {}", t, id, ev)
        @match ev begin
            "arrived" => (  event_times_by_customer[id, 1] = t;
                            println("    queued getting in line event");
                            println("peek: ", peek(events));
                            enqueue!(events, t + SHOPPING_TIME, ("queued", id))
                        )
            "queued"  => (  event_times_by_customer[id, 2] = t;
                            len_on_enter[id] = length(queue);
                            # len_on_enter[id] = line_len;
                            println("    with $(length(queue)) people in line");
                            wait_time_by_customer[id] = t;

                            push!(queue, id);
                            if n_available_cashiers > 0
                                println("    the line was empty!")
                                enqueue!(events, t, ("dequeued", id))
                            end
                        )
            "dequeued" => ( event_times_by_customer[id, 3] = t;
                            wait_time_by_customer[id] = t-wait_time_by_customer[id];
                            @assert id == popfirst!(queue);
                            println("    after waiting $(wait_time_by_customer[id]) mins");
                            enqueue!(events, t + samples_checko[id], ("done_serving", id));
                            n_available_cashiers -= 1;
                        )
            "done_serving" => (
                            event_times_by_customer[id, 4] = t;
                            n_available_cashiers += 1;
                            if length(queue) > 0
                                enqueue!(events, t, ("dequeued", queue[1]))
                            end 
                        )
            unk => println("- unknown event $unk")
        end
    end

    # post processing metrics
    # pushfirst!(wait_time_by_customer, zeros(n_customers))
    println(event_times_by_customer);
    # plot(map(x -> (x, 1:4)))
    for customer in 1:n_customers
        println("plotting customer number $customer")
        plot!(event_times_by_customer[customer, :], 1:4, linetype=:steppre);
    end
    gui();
    readline();

    println(len_on_enter);
end

simulate(CUSTOMERS)
# 
# line_len = 0
# # while 
# 
# println(samples_arrive)
# println(samples_checko)
# # histogram(samples_checko); gui(); readline()
# 
# leave_time_without_delay = samples_arrive + samples_checko
# wait_time = max.(cumsum(samples_checko) - samples_arrive, 0)
# println(samples_arrive)
# println(wait_time)
# 
# 
