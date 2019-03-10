moduleof(m::Method) = m.module
functiontypeof(m::Method) = _functiontypeof(m.sig)
_functiontypeof(sig::UnionAll) = _functiontypeof(sig.body)
_functiontypeof(sig::DataType) = sig.parameters[1]

# Last method will always be closest to the types we provided
function methodof(f, args...)
    try
        methods(f, Tuple{typeof.(args)...}).ms[end]
    catch
        @warn "Determining methods failed" f arg_types=typeof.(args)
        rethrow()
    end
end

methodof(::Core.Builtin, args...) = nothing  # No methods for `Builtin`s

#TODO: Methods are actually pretty slow to construct. 1-2μs and 8-15 allocations
# when we construct them ourself we are only really using them has a container for
# function, args types and module.
# We could define out own `LightMethod`, which exposes also overloads the above
# functions, while still keeping them working on real methods. And then just use that

