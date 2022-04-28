println("compiled... executing")
using Distributions, Random
using Plots; gr()
using DataStructures
using Match
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

# samples_arrive, samples_checko = floor.(samples_arrive), floor.(samples_checko)

    samples_arrive  = cumsum(samples_arrive)                        # T_k
    # wait_cumsum = zeros(n_customers + 1)
    # wait_cumsum[2:end] = cumsum(samples_checko)                     # leaving time

    events = PriorityQueue()
    for (i, t) in enumerate(samples_arrive)
        enqueue!(events, t=>("arrived", i))
    end 

    len_on_enter = zeros(Int, n_customers)

    queue = []
    wait_time_by_customer = zeros(n_customers)

    # event loop
    while length(events) > 0
        (t, (ev, id)) = dequeue_pair!(events)
        printfmtln("at time {:.2f}, {} {}", t, id, ev)
        @match ev begin
            "arrived" => (  enqueue!(events, t + 15 => ("queued", id))
                        )
            "queued"  => (  len_on_enter[id] = length(queue);
                            # len_on_enter[id] = line_len;
                            println("    with $(length(queue)) people in line");
                            wait_time_by_customer[id] = t;

                            push!(queue, id);
                            if length(queue) == 0
                                enqueue!(events, t => ("dequeued", id))
                            end

                            # if length(queue) > 0
                            #     push!(queue, id);
                            # else
                            #     enqueue!(events, t => ("dequeued", id))
                            # end 


                            # println("    waiting $(wait_cumsum[id] - t)");
                            # wait_time = wait_cumsum[id] - t;
                            # enqueue!(events, t + wait_time + samples_checko[id] => ("dequeued", id));
                            # line_len += 1;
                        )
            "dequeued" => ( wait_time_by_customer[id] = t-wait_time_by_customer[id];
                            @assert id == popfirst!(queue);
                            enqueue!(events, t + samples_checko
                                                 => ("done_serving", id))
                    )
            "done_serving" => (
                            if length(queue) > 0
                                enqueue!(events, t => ("dequeued", queue[1]))
                            end 
                    )
            unk => println("- unknown event $unk")
        end
    end

    println(len_on_enter)
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
