#-------------------------------------------------------------------------------
# Will extend the array of primes if possibly inadequate for factorization
function divisors!(n::Int, primes::Array{Int,1})
# Genarate a "code" that is a mixed base number
# The values of the "code" ranges from 0 to (number of divisors - 1)
# The "code" is broken down into digits
# The number of digits is equal to the number of prime factors.
# The base of each digit is the corresponding prime factor's power plus one.
    if n  < 1;    throw(DomainError("n must be greater than zero."));    end
    if n == 1;    return [1]; end


    factors = factorization!(n, primes)
    numDvrs = Int64(1)
    for factor in factors
        numDvrs *= (factor[2] + 1)
    end

    res = Int64[1] # 1 is always a divisor
    codeMax = numDvrs - 2
    for code = 1 : codeMax


        rem = code
        dvr = Int64(1)
        i = 1

        while rem > 0
            pwr = rem % (factors[i][2] + 1)
            dvr *= factors[i][1]^pwr
            rem ÷= (factors[i][2] + 1)
            i += 1
        end

        push!(res, dvr)
    end
    push!(res, n) # n is always a divisor


    sort(res) # If you don't need the divisors sorted, just return res
end
#-------------------------------------------------------------------------------



#-------------------------------------------------------------------------------
function divisors(factorization::Array{Array{Int64,1},1})
# Genarate a "code" that is a mixed base number
# The values of the "code" ranges from 0 to (number of divisors - 1)
# The "code" is broken down into digits
# The number of digits is equal to the number of prime factors.
# The base of each digit is the corresponding prime factor's power plus one.
    if factorization == []
        throw("Empty array passed to function divisors().")
    end



    numDvrs = Int(1)
    for factor in factorization
        numDvrs *= (factor[2] + 1)
    end

    res = Int128[1] # when code = 0, the divisor is 1
    codeMax = numDvrs - 1
    for code = 1 : codeMax
        rem = code
        dvr = Int128(1)
        i = 1

        while rem > 0
            pwr = rem % (factorization[i][2] + 1)
            dvr *= convert(Int128, factorization[i][1])^pwr
            rem ÷= (factorization[i][2] + 1)
            i += 1
        end

        push!(res, dvr)
    end


    sort(res) # If you don't need the divisors sorted, just return res
end
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Will extend the array of primes if possibly inadequate for factorization
function factorization!(n::Int, primes::Array{Int,1})

    if n  < 1;    throw(DomainError("n must be greater than zero."));    end
    if n == 1;    return []; end


    res = [] # result

    # Extend the array of primes if it may be inadequate
    sqrt_n_up = convert(Int64, ceil(√n))
    if length(primes) ==  0  ||  sqrt_n_up > last(primes)
        primes′ = sieve(2sqrt_n_up)
        for i = length(primes) + 1 : length(primes′)
            push!(primes, primes′[i])
        end
    end

    rem = n
    sqrt_rem_down = convert(Int64, floor(√rem))
    i = 1
    while rem ≠ 1  &&  primes[i] ≤ sqrt_rem_down
        if rem % primes[i] == 0
            rem ÷= primes[i]
            pwr = 1
            while rem % primes[i] == 0
                rem ÷= primes[i]
                pwr += 1
            end
            push!(res, [primes[i], pwr])
        end
        sqrt_rem_down = convert(Int64, floor(√rem)) # Speed up or slow down?
        i += 1
    end

    if rem ≠ 1;    push!(res, [rem, 1]);    end



    res # returned
end
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Implementation of the Sieve of Eratosthenes where we take advantage of
# the option to iterate a for loop by more than 1.  Multiplying two numbers to
# get an odd would imply that both of those numbers were also odd.
function sieve(n::Int)
    if n < 2;    return []; end
    primes = Int64[2]
    sizehint!(primes, convert( Int64, floor( n / log(n) ) ))
    oddsAlive = trues((n-1) ÷ 2) # oddsAlive[i] represents 2i + 1

    i_sqrt = (convert( Int64, floor(√n) ) - 1) ÷ 2
    for i = 1 : i_sqrt
        if oddsAlive[i] # It's prime.  Kill odd multiples of it
            push!(primes, 2i + 1)
            Δᵢ = 2i + 1
            for iₓ = i+Δᵢ : Δᵢ : length(oddsAlive);   oddsAlive[iₓ] = false; end
        end
    end
    for i = i_sqrt + 1 : length(oddsAlive) # Surviving odds also prime
        if oddsAlive[i];    push!(primes, 2i + 1); end
    end

    primes
end
#-------------------------------------------------------------------------------
