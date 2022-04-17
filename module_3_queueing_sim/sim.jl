println("compiled... executing")
using Distributions, Random
using Plots; gr()
using DataStructures
using Match
using Formatting    # https://stackoverflow.com/a/37032242

SEED = 1338
# ROUNDS = Int(1e4)
ROUNDS = Int(4)

lambda_arrive, lambda_checko = 5, 1
# lambda_arrive, lambda_checko = 10, 10

d = Exponential(lambda_arrive) # https://discourse.julialang.org/t/sampling-from-a-normal-distribution/36848

Random.seed!(SEED)
println("sampling...")
samples_arrive = rand(Exponential(lambda_arrive), ROUNDS)
samples_checko = rand(Exponential(lambda_checko), ROUNDS)

# samples_arrive, samples_checko = floor.(samples_arrive), floor.(samples_checko)

samples_arrive = cumsum(samples_arrive)

events = PriorityQueue()
for (i, t) in enumerate(samples_arrive)
    enqueue!(events, t=>("arrived", i))
end 

while length(events) > 0
    (t, (ev, id)) = dequeue_pair!(events)
    printfmtln("at time {:.2f}, {} {}", t, id, ev)
    @match ev begin
        "arrived" => enqueue!(events, t + 15 => ("inline", id))
        unk => println("unknown event $unk")
    end
end
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
