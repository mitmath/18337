### A Pluto.jl notebook ###
# v0.20.20

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    return quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ 01ab2b8f-cb97-425b-9c43-e7f2889dfb7d
begin 
	using PlutoUI
	using StatsBase
	using LinearAlgebra
	using Gadfly
	using Compose
end

# ╔═╡ b5fb46e8-ff75-4eb1-ba63-92e3b4a764fe
n = @bind n Slider(1:10; default=8, show_value=true)

# ╔═╡ 2670e66e-bc2a-11ed-2f25-c554deffd3bf
reduce(+, 1:n), sum(1:n)  # triangular numbers

# ╔═╡ ee52bbc2-1e4a-47e4-8b43-8cb0e730069d
reduce(*, 1:n), prod(1:n) # factorials

# ╔═╡ d3e62a10-69ef-47c3-8ab3-4d1299bbfc82
begin	
	boring(a,b)=a
	reduce(boring, Vector('a':'z')[1:n])
end

# ╔═╡ 82b5c025-9ae1-461e-bf88-c6be0ed093f7
begin
	boring2(a,b)=b
	reduce(boring2, Vector('a':'z')[1:n])
end

# ╔═╡ ab0a8204-65ee-459d-98be-6087187b4096
M=[1 1; 1 0]

# ╔═╡ 6a673be9-c6c0-4dce-b970-74f3e68fc990
N = @bind N Slider(1:100; default=8, show_value=true)

# ╔═╡ a2642146-a331-48a2-9a6c-850b3debe241
prod(fill(big.(M),N))

# ╔═╡ 0e1005c7-47b7-493f-99e6-be069e944c8b
begin
	fib(j)=reduce(*, fill(M,j))
	fib.([4,7])
end

# ╔═╡ 8839cc30-2d1d-4c43-bccf-82944ee2a166
begin
	A=[1 2;3 4]
	B=[10 100; 1 -10]
	⊗(A,B)=kron(A,B)
	
	let M=[ 1 1;1 -1]
		H=⊗(⊗(⊗(M,M),M),M)
		H*H'
	end
end

# ╔═╡ e5e40188-08df-4b82-a776-86e645f925ff
begin
	Hadamard(n)=reduce(⊗, fill([1 1;1 -1],n))
	H = Hadamard(3)
end

# ╔═╡ 56d09724-e48f-4003-a168-0ef2e000e2ec
H'H

# ╔═╡ 5c285f77-31e6-4636-8702-7e99ed173491
H*H' #This is a legitimate Hadamard matrix

# ╔═╡ b07ded7a-21fb-4bcf-a4a7-96d6c73a0ee8
begin 
	rolldice() = rand(1:6)+rand(1:6)
	rolls(n)=fit(Histogram,[rolldice() for i=1:n ],2:12,closed=:left)
end

# ╔═╡ 3a93cb87-6e17-4fe4-a87c-db3ceb1a9fb8
rolls(1000)

# ╔═╡ 7d3b7168-ceea-484a-831b-dbf53dd3ac10
reduce(merge,[rolls(100) for i=1:10])

# ╔═╡ 61e583f4-b9f9-4727-bd0c-07360382cbf6
let 
M=[rand(-3:3,2,2) for i=1:4]


(M[4]*M[3]*M[2]*M[1], 
 reduce((A,B)->B*A, M), #backward multiply
 reduce(*, M)
)
end

# ╔═╡ 861d9a43-24c9-4cec-b82f-94a1b547c5b8
(sin ∘ cos)(1), sin(cos(1))

# ╔═╡ 7ba55f3d-509f-41a8-af58-95f3293ebe96
((-) ∘ sin)(1), -sin(1)

# ╔═╡ e7a16f12-4d98-4caf-9161-31035d971ec3
begin
	h=reduce(∘, [sin cos tan])
	[h(π) sin(cos(tan(π)))]
end

# ╔═╡ e6fffc89-420d-40af-b9ab-d23a56a72bf3
begin
	cumsum(1:8)  # It is useful to know that cumsum is a linear operator
	# You can use power method! Below is the underlying matrix
	Ac=tril(ones(Int,8,8)) 
end

# ╔═╡ 3738164e-73d3-4b13-8386-26d1dfca3983
(Ac*(1:8),cumsum(1:8))

# ╔═╡ a9aa8aec-c265-4bf9-9b15-1c810cbb0b7e
mutable struct DummyArray
    length :: Int
    read :: Vector
    history :: Vector{Any}
    DummyArray(length, read=[], history=[])=new(length, read, history)
end

# ╔═╡ 087e4786-a933-47df-8526-60d20df63271
begin
	Base.length(A::DummyArray)=A.length

	function Base.getindex(A::DummyArray, i)
	    push!(A.read, i)
	    missing
	end
	
	function Base.setindex!(A::DummyArray, x, i)
	    push!(A.history, (A.read, [i]))
	    A.read = []
	end

	
end

# ╔═╡ 531b3af5-07e1-4823-818d-ab540865494b
md"### Reduce"

# ╔═╡ 5e3f0741-fe66-4ccb-822f-63cda1b2c89b
md"""
Sum Reduce\
Example: Triangular Numbers
"""

# ╔═╡ 4a77c84d-6a7b-4dd3-8701-ab405adb364b
md"Example: Factorials"

# ╔═╡ 206df737-3eb2-4275-861a-a0ba958c23d1
md"Examples: Boring"

# ╔═╡ 36a0f36a-1d3f-40c8-8514-7a94ad7ea5c9
md"""
Example:Fibonacci

``\begin{pmatrix} f_2 \\ f_1 \end{pmatrix} = \begin{pmatrix} f_1 + f_0 \\ f_1 \end{pmatrix}``

``\begin{pmatrix} 1 & 1 \\ 1 & 0 \end{pmatrix}^n = \begin{pmatrix} f_{n+1} & f_n\\  f_n & f_{n-1} \\  \end{pmatrix}``


"""

# ╔═╡ 829b05e4-df24-46ed-981a-2bee358ae0aa
md"""
You can solve recurrences of any complexity using `reduce`. For example, `reduce` can compute a Hadamard matrix from its definition in terms of its submatrices:

`` H_2 = \begin{pmatrix} H_1 & H_1 \\ H_1 & -H_1 \end{pmatrix} = \begin{pmatrix} 1 & 1 \\ 1 & -1 \end{pmatrix} \otimes H_1 ``

and so on. 

(Note: this is just using reduce to compute a matrix power.\n",
    "One can think of alternative ways for sure.
"""

# ╔═╡ d0ba43bc-18e4-4ccc-aa9d-d83285ea59b2
md"""
```
# [A B]
# If A is m x n
# If B is p x q
# then kron(A,B) is mp x nq and has all the elements of A 
```
"""

# ╔═╡ 47c9d5a3-274b-4612-a835-db3fadd3373e
md"""
In the following example we apply `reduce` to function composition:
"""

# ╔═╡ bd0267c5-2047-43e4-851e-dadfc25d1ed9
md"""
## `prefix`

Having discussed `reduce`, we are now ready for the idea behind prefix sum. Prefix or scan is long considered an important parallel primitive as well.

Suppose you wanted to compute the partial sums of a vector, i.e. given `y[1:n]`, we want to overwrite the vector y with the vector of partial sums.

```julia
new_y[1] = y[1]
new_y[2] = y[1] + y[2]
new_y[3] = y[1] + y[2] + y[3]
...
```

At first blush, it seems impossible to parallelize this, since

```julia
new_y[1] = y[1]
new_y[2] = new_y[1] + y[2]
new_y[3] = new_y[2] + y[3]
...
```

which appears to be an intrinsically serial process.
"""

# ╔═╡ 8322a1cf-0236-49b3-a169-f8ae7b4eedb7
function prefix_serial!(y, ⊕)
    for i=2:length(y)
        y[i] = y[i-1] ⊕ y[i]
        end
    y
end

# ╔═╡ 434211b7-1055-47d2-aa44-b4b2d9f97203
prefix_serial!([1:8;],*)

# ╔═╡ be349102-60fc-4d27-aa5a-f1f74a96109b
prefix_serial!([rand(1:5,2,2) for i=1:4],*)

# ╔═╡ 05d88bce-6bf7-415c-bee1-a45f8eeb0b34
md"""
However, it turns out that because addition `(+)` is associative, we can regroup the order of how these sums are carried out. (This of course extends to other associative operations such as multiplication.) Another ordering of 8 associative operations is provided by `prefix8!`:
"""

# ╔═╡ 96b1616b-9ea6-4a11-b4b2-9a4464c36ab9
# Eight only for pedagogy
function prefix8!(y, ⋅)
    length(y)==8 || error("length 8 only")
    for i in [2,4,6,8]; y[i] = y[i-1] ⋅ y[i]; end
    for i in [  4,  8]; y[i] = y[i-2] ⋅ y[i]; end
    for i in [      8]; y[i] = y[i-4] ⋅ y[i]; end
    for i in [    6  ]; y[i] = y[i-2] ⋅ y[i]; end
    for i in [ 3,5,7 ]; y[i] = y[i-1] ⋅ y[i]; end
    y
end

# ╔═╡ f2d04cda-df53-4867-ac56-f597267cc807
# Generalization to any n
function prefix!(y, ⋅)
    l=length(y)
    k=ceil(Int, log2(l))
    @inbounds for j=1:k, i=2^j:2^j:min(l, 2^k)              #"reduce"
        y[i] = y[i-2^(j-1)] ⋅ y[i]
    end
    @inbounds for j=(k-1):-1:1, i=3*2^(j-1):2^j:min(l, 2^k) #"broadcast"
        y[i] = y[i-2^(j-1)] ⋅ y[i]
    end
    y
end

# ╔═╡ be1208cb-1621-469a-b41a-d7411f66e91d
prefix!([1:12;],*)

# ╔═╡ 947d4c14-dd06-41ba-9edf-e09b9c55aacb
md"""
## Polymorphism for visualization

We can visualize the operations with a little bit of trickery. In Julia, arrays are simply types that expose the array protocol. In particular, they need to implement methods for the generic functions `length`, `getindex` and `setindex!`. The last two are used in indexing operations, since statements

```julia
y = A[1]
A[3] = y
```

get desugared to

```julia
y = getindex(A, 1)
setindex!(A, y, 3)
```

respectively.

We can trace through the iterable by introduce a dummy array type, `DummyArray`, which stores no useful information but records every access to `getindex` and `setindex!`.

Specifically:

- `length(A::DummyArray)` returns an integer that is stored internally in the `A.length `field
- `getindex(A::DummyArray, i)` records read access to the index `i` in the `A.read` field and always returns `missing`.
- `setindex!(A::DummyArray, x, i)` records write access to the index `i`. The `A.history` field is appended with a new tuple consisting of the current `A.read` field and the index `i`.

The way `DummyArray` works, it assumes an association between a single `setindex!` call and and all the preceding `getindex` calls since the previous `setindex!` call, which is sufficient for the purposes of tracing through prefix calls.
"""

# ╔═╡ 54f9bed6-37f0-4b9e-901c-f4c5fb9ca2ba
let
	M = DummyArray(4)
	M[7] = M[3] + M[2]
	M
end

# ╔═╡ bdf9341c-ec26-423e-985d-834903c2eac0
DummyA = prefix8!(DummyArray(8),+)

# ╔═╡ af31d1d7-ae8e-4400-aeb4-cb42ce0c4ec7
DummyA.history

# ╔═╡ 8eec5baf-02a8-4414-a761-37612bbccae9
md"""
Now let's visualize this! Each entry in A.history is rendered by a gate object:
"""

# ╔═╡ 104438b2-1ad4-4ec8-89eb-e5c0b3225525
struct Gate
	ins :: Vector
    outs:: Vector
end

# ╔═╡ ec968447-7496-42c4-b5b7-5fda3e899e29
function Gadfly.render(G::Gate, x₁, y₁, y₀; rᵢ=0.1, rₒ=0.25)
    ipoints = [(i, y₀+rᵢ) for i in G.ins]
    opoints = [(i, y₀+0.5) for i in G.outs]
    igates  = [Compose.circle(i..., rᵢ) for i in ipoints]
    ogates  = [Compose.circle(i..., rₒ) for i in opoints]
    lines = [line([i, j]) for i in ipoints, j in opoints]
    compose(context(units=UnitBox(0.5,0,x₁,y₁+1)),
    compose(context(), stroke(colorant"black"), fill(colorant"white"),
            igates..., ogates...),
    compose(context(), linewidth(0.3mm), stroke(colorant"black"),
            lines...))
end

# ╔═╡ 4bf453fe-97a2-4f28-ad46-f10eb253cc8b
function Gadfly.render(A::DummyArray)
    #Scan to find maximum depth
    olast = depth = 0
    for y in A.history
        (any(y[1] .≤ olast)) && (depth += 1)
        olast = maximum(y[2])
    end
    maxdepth = depth
    
    olast = depth = 0
    C = []
    for y in A.history
        (any(y[1] .≤ olast)) && (depth += 1)
        push!(C, render(Gate(y...), A.length, maxdepth, depth))
        olast = maximum(y[2])
    end
    
    push!(C, compose(context(units=UnitBox(0.5,0,A.length,1)),
      [line([(i,0), (i,1)]) for i=1:A.length]...,
    linewidth(0.1mm), stroke(colorant"grey")))
    compose(context(), C...)
end

# ╔═╡ 8c9cfbd2-96e1-4d76-9b09-a5c35e5a5e17
render(Gate([1,2],[2]),2,0,0)

# ╔═╡ d9b1b5b9-3415-4fcf-96c7-e22628e51e4c
render(prefix!(DummyArray(8), +))

# ╔═╡ 0e4afe65-a002-48b0-9206-8f9e36954dff
md"""
Now we can see that prefix! rearranges the operations to form two spanning trees:
"""

# ╔═╡ 56dfc572-3a75-4846-bb41-811c4ddb42f8
render(prefix!(DummyArray(120),+))

# ╔═╡ fdb173ff-2aea-443d-a99b-ed5f95279edb
render(prefix!(DummyArray(9),+))

# ╔═╡ 9f7e6763-e2ef-424e-8dee-0aebf3f74816
render(prefix_serial!(DummyArray(8),+))

# ╔═╡ d40c697d-89d2-4194-974e-ef778baa5d7b
npp = @bind npp Slider(1:180; default=20, show_value=true)

# ╔═╡ 7b48451a-028c-48a4-ba9e-5975cbd656d4
render(prefix!(DummyArray(npp),+))

# ╔═╡ cf94afa3-779d-4c4e-bd24-2e86d923d337
render(prefix_serial!(DummyArray(npp),+))

# ╔═╡ c5ccea9d-1a5f-4a9c-8424-5904532b35af
# Generalization to any n
function prefix_kogge_stone!(y, ⋅)
    l=length(y)
    k=ceil(Int, log2(l))

     for j=1:k
		  i=2^(j-1)
		    y[i+1:l] = y[1:l-i] .⋅ y[i+1:l]	  
		  println(y)
	 end
	 y
end

# ╔═╡ 01f7a94b-1b4d-4731-8185-7f894263ce1f
prefix_kogge_stone!([1,2,3,4,5,6,7,8],+)

# ╔═╡ 9804906f-8489-4185-abad-0064bd1c610d
function prefix_kogge_stone2!(y, ⋅)
    l=length(y)
    k=ceil(Int, log2(l))

     for j=1:k
		  i=2^(j-1)
		  for m = l:-1:(i+1)
		    y[m] = y[m-i] .⋅ y[m]	 
		  end
		  #println(y)
	 end
	 y
end

# ╔═╡ 2ed31d97-6e9d-4bf6-8bdb-2afb2bb4a776
prefix_kogge_stone2!([1,2,3,4,5,6,7,8],+)

# ╔═╡ 295f2954-498b-4df3-8ef6-f7b3f427f08b
npp2 = @bind npp2 Slider(1:180; default=20, show_value=true)

# ╔═╡ ba0bb57a-6a7b-47dd-844c-204ed0e0aec7
render(prefix_kogge_stone2!(DummyArray(npp2),+))

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Compose = "a81c6b42-2e10-5240-aca2-a61377ecd94b"
Gadfly = "c91e804a-d5a3-530f-b6f0-dfbca275c004"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"

[compat]
Compose = "~0.9.5"
Gadfly = "~1.3.4"
PlutoUI = "~0.7.50"
StatsBase = "~0.33.21"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.12.1"
manifest_format = "2.0"
project_hash = "3f9e652acd4ff91f3a461d8b2067727014c4bd59"

[[deps.AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "d92ad398961a3ed262d8bf04a1a2b8340f915fef"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.5.0"
weakdeps = ["ChainRulesCore", "Test"]

    [deps.AbstractFFTs.extensions]
    AbstractFFTsChainRulesCoreExt = "ChainRulesCore"
    AbstractFFTsTestExt = "Test"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "35ea197a51ce46fcd01c4a44befce0578a1aaeca"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "4.5.0"
weakdeps = ["SparseArrays", "StaticArrays"]

    [deps.Adapt.extensions]
    AdaptSparseArraysExt = "SparseArrays"
    AdaptStaticArraysExt = "StaticArrays"

[[deps.AliasTables]]
deps = ["PtrArrays", "Random"]
git-tree-sha1 = "9876e1e164b144ca45e9e3198d0b689cadfed9ff"
uuid = "66dad0bd-aa9a-41b7-9441-69ab47430ed8"
version = "1.1.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "01b8ccb13d68535d73d2b0c23e39bd23155fb712"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.1.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.CategoricalArrays]]
deps = ["DataAPI", "Future", "Missings", "Printf", "Requires", "Statistics", "Unicode"]
git-tree-sha1 = "f6d71f5b1b09e1a2115efd3bba69123691c15f2b"
uuid = "324d7699-5711-5eae-9e2f-1d82baa6b597"
version = "0.10.9"

    [deps.CategoricalArrays.extensions]
    CategoricalArraysArrowExt = "Arrow"
    CategoricalArraysJSONExt = "JSON"
    CategoricalArraysRecipesBaseExt = "RecipesBase"
    CategoricalArraysSentinelArraysExt = "SentinelArrays"
    CategoricalArraysStructTypesExt = "StructTypes"

    [deps.CategoricalArrays.weakdeps]
    Arrow = "69666777-d1a9-59fb-9406-91d4454c9d45"
    JSON = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
    RecipesBase = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
    SentinelArrays = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
    StructTypes = "856f2bd8-1eba-4b0a-8007-ebc267875bd4"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra"]
git-tree-sha1 = "e4c6a16e77171a5f5e25e9646617ab1c276c5607"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.26.0"
weakdeps = ["SparseArrays"]

    [deps.ChainRulesCore.extensions]
    ChainRulesCoreSparseArraysExt = "SparseArrays"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "362a287c3aa50601b0bc359053d5c2468f0e7ce0"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.11"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "9d8a54ce4b17aa5bdce0ea5c34bc5e7c340d16ad"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.18.1"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.3.0+1"

[[deps.Compose]]
deps = ["Base64", "Colors", "DataStructures", "Dates", "IterTools", "JSON", "LinearAlgebra", "Measures", "Printf", "Random", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "bf6570a34c850f99407b494757f5d7ad233a7257"
uuid = "a81c6b42-2e10-5240-aca2-a61377ecd94b"
version = "0.9.5"

[[deps.Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[deps.CoupledFields]]
deps = ["LinearAlgebra", "Statistics", "StatsBase"]
git-tree-sha1 = "6c9671364c68c1158ac2524ac881536195b7e7bc"
uuid = "7ad07ef1-bdf2-5661-9d2b-286fd4296dac"
version = "0.2.0"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "4e1fe97fdaed23e9dc21d4d664bea76b65fc50a0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.22"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Distances]]
deps = ["LinearAlgebra", "Statistics", "StatsAPI"]
git-tree-sha1 = "c7e3a542b999843086e2f29dac96a618c105be1d"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.12"
weakdeps = ["ChainRulesCore", "SparseArrays"]

    [deps.Distances.extensions]
    DistancesChainRulesCoreExt = "ChainRulesCore"
    DistancesSparseArraysExt = "SparseArrays"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"
version = "1.11.0"

[[deps.Distributions]]
deps = ["AliasTables", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns"]
git-tree-sha1 = "fbcc7610f6d8348428f722ecbe0e6cfe22e672c6"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.123"

    [deps.Distributions.extensions]
    DistributionsChainRulesCoreExt = "ChainRulesCore"
    DistributionsDensityInterfaceExt = "DensityInterface"
    DistributionsTestExt = "Test"

    [deps.Distributions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DensityInterface = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
    Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "Libdl", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "97f08406df914023af55ade2f843c39e99c5d969"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.10.0"

[[deps.FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6d6219a004b8cf1e0b4dbe27a2860b8e04eba0be"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.11+0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.FillArrays]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "2f979084d1e13948a3352cf64a25df6bd3b4dca3"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.16.0"
weakdeps = ["PDMats", "SparseArrays", "StaticArrays", "Statistics"]

    [deps.FillArrays.extensions]
    FillArraysPDMatsExt = "PDMats"
    FillArraysSparseArraysExt = "SparseArrays"
    FillArraysStaticArraysExt = "StaticArrays"
    FillArraysStatisticsExt = "Statistics"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"
version = "1.11.0"

[[deps.Gadfly]]
deps = ["Base64", "CategoricalArrays", "Colors", "Compose", "Contour", "CoupledFields", "DataAPI", "DataStructures", "Dates", "Distributions", "DocStringExtensions", "Hexagons", "IndirectArrays", "IterTools", "JSON", "Juno", "KernelDensity", "LinearAlgebra", "Loess", "Measures", "Printf", "REPL", "Random", "Requires", "Showoff", "Statistics"]
git-tree-sha1 = "13b402ae74c0558a83c02daa2f3314ddb2d515d3"
uuid = "c91e804a-d5a3-530f-b6f0-dfbca275c004"
version = "1.3.4"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.Hexagons]]
deps = ["Test"]
git-tree-sha1 = "de4a6f9e7c4710ced6838ca906f81905f7385fd6"
uuid = "a1b4810d-1bce-5fbd-ac56-80944d57a21f"
version = "0.2.0"

[[deps.HypergeometricFunctions]]
deps = ["LinearAlgebra", "OpenLibm_jll", "SpecialFunctions"]
git-tree-sha1 = "68c173f4f449de5b438ee67ed0c9c748dc31a2ec"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.28"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl"]
git-tree-sha1 = "ec1debd61c300961f98064cfb21287613ad7f303"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2025.2.0+0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.Interpolations]]
deps = ["Adapt", "AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "65d505fa4c0d7072990d659ef3fc086eb6da8208"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.16.2"

    [deps.Interpolations.extensions]
    InterpolationsForwardDiffExt = "ForwardDiff"
    InterpolationsUnitfulExt = "Unitful"

    [deps.Interpolations.weakdeps]
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.IrrationalConstants]]
git-tree-sha1 = "b2d91fe939cae05960e760110b328288867b5758"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.6"

[[deps.IterTools]]
git-tree-sha1 = "42d5f897009e7ff2cf88db414a389e5ed1bdd023"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.10.0"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "0533e564aae234aff59ab625543145446d8b6ec2"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.7.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JuliaSyntaxHighlighting]]
deps = ["StyledStrings"]
uuid = "ac6e5ff7-fb65-4e79-a425-ec3bc9c03011"
version = "1.12.0"

[[deps.Juno]]
deps = ["Base64", "Logging", "Media", "Profile"]
git-tree-sha1 = "07cb43290a840908a771552911a6274bc6c072c7"
uuid = "e5e0dc1b-0480-54bc-9374-aad01c23163d"
version = "0.8.4"

[[deps.KernelDensity]]
deps = ["Distributions", "DocStringExtensions", "FFTW", "Interpolations", "StatsBase"]
git-tree-sha1 = "ba51324b894edaf1df3ab16e2cc6bc3280a2f1a7"
uuid = "5ab0869b-81aa-558d-bb23-cbf5423bbe9b"
version = "0.6.10"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"
version = "1.11.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "OpenSSL_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.11.1+1"

[[deps.LibGit2]]
deps = ["LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "OpenSSL_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.9.0+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "OpenSSL_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.3+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.12.0"

[[deps.Loess]]
deps = ["Distances", "LinearAlgebra", "Statistics"]
git-tree-sha1 = "46efcea75c890e5d820e670516dc156689851722"
uuid = "4345ca2d-374a-55d4-8d30-97f9976e7612"
version = "0.5.4"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "13ca9e2586b89836fd20cccf56e57e2b9ae7f38f"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.29"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "oneTBB_jll"]
git-tree-sha1 = "282cadc186e7b2ae0eeadbd7a4dffed4196ae2aa"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2025.2.0+0"

[[deps.MacroTools]]
git-tree-sha1 = "1e0228a030642014fe5cfe68c2c0a818f9e3f522"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.16"

[[deps.Markdown]]
deps = ["Base64", "JuliaSyntaxHighlighting", "StyledStrings"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.Measures]]
git-tree-sha1 = "b513cedd20d9c914783d8ad83d08120702bf2c77"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.3"

[[deps.Media]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "75a54abd10709c01f1b86b84ec225d26e840ed58"
uuid = "e89f7d12-3494-54d1-8411-f7d8b9ae1f27"
version = "0.5.0"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2025.5.20"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.3.0"

[[deps.OffsetArrays]]
git-tree-sha1 = "117432e406b5c023f665fa73dc26e79ec3630151"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.17.0"
weakdeps = ["Adapt"]

    [deps.OffsetArrays.extensions]
    OffsetArraysAdaptExt = "Adapt"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.29+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.7+0"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.5.1+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1346c9208249809840c91b26703912dff463d335"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.6+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "05868e21324cede2207c6f0f466b4bfef6d5e7ee"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.8.1"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "f07c06228a1c670ae4c87d1276b92c7c597fdda0"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.35"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "7d2f8f21da5db6a806faf7b9b292296da42b2810"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.3"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.12.0"
weakdeps = ["REPL"]

    [deps.Pkg.extensions]
    REPLExt = "REPL"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "5bb5129fdd62a2bbbe17c2756932259acf467386"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.50"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "07a921781cab75691315adc645096ed5e370cb77"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.3.3"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "8b770b60760d4451834fe79dd483e318eee709c4"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.5.2"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.Profile]]
deps = ["StyledStrings"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"
version = "1.11.0"

[[deps.PtrArrays]]
git-tree-sha1 = "4fbbafbc6251b883f4d2705356f3641f3652a7fe"
uuid = "43287f4e-b6f4-7ad1-bb20-aadabca52c3d"
version = "1.4.0"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "9da16da70037ba9d701192e27befedefb91ec284"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.11.2"

    [deps.QuadGK.extensions]
    QuadGKEnzymeExt = "Enzyme"

    [deps.QuadGK.weakdeps]
    Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"

[[deps.REPL]]
deps = ["InteractiveUtils", "JuliaSyntaxHighlighting", "Markdown", "Sockets", "StyledStrings", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "1342a47bf3260ee108163042310d26f2be5ec90b"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.5"
weakdeps = ["FixedPointNumbers"]

    [deps.Ratios.extensions]
    RatiosFixedPointNumbersExt = "FixedPointNumbers"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "62389eeff14780bfe55195b7204c0d8738436d64"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.1"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "5b3d50eb374cea306873b371d3f8d3915a018f0b"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.9.0"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "58cdd8fb2201a6267e1db87ff148dd6c1dbd8ad8"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.5.1+0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"
version = "1.11.0"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"
version = "1.11.0"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "64d974c2e6fdf07f8155b5b2ca2ffa9069b608d9"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.2"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.12.0"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "2700b235561b0335d5bef7097a111dc513b8655e"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.7.2"
weakdeps = ["ChainRulesCore"]

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "246a8bb2e6667f832eea063c3a56aef96429a3db"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.18"
weakdeps = ["ChainRulesCore", "Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "6ab403037779dae8c514bad259f32a447262455a"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.4"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"
weakdeps = ["SparseArrays"]

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "178ed29fd5b2a2cfc3bd31c13375ae925623ff36"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.8.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[deps.StatsFuns]]
deps = ["HypergeometricFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "91f091a8716a6bb38417a6e6f274602a19aaa685"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.5.2"

    [deps.StatsFuns.extensions]
    StatsFunsChainRulesCoreExt = "ChainRulesCore"
    StatsFunsInverseFunctionsExt = "InverseFunctions"

    [deps.StatsFuns.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.StyledStrings]]
uuid = "f489334b-da3d-4c2e-b8f0-e476e12c162b"
version = "1.11.0"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.8.3+2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.Tricks]]
git-tree-sha1 = "311349fd1c93a31f783f977a71e8b062a57d4101"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.13"

[[deps.URIs]]
git-tree-sha1 = "bef26fb046d031353ef97a82e3fdb6afe7f21b1a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.6.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "248a7031b3da79a127f14e5dc5f417e26f9f6db7"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "1.1.0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.3.1+2"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.15.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.64.0+1"

[[deps.oneTBB_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl"]
git-tree-sha1 = "1350188a69a6e46f799d3945beef36435ed7262f"
uuid = "1317d2d5-d96f-522e-a858-c73665f53c3e"
version = "2022.0.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.5.0+2"
"""

# ╔═╡ Cell order:
# ╠═01ab2b8f-cb97-425b-9c43-e7f2889dfb7d
# ╟─531b3af5-07e1-4823-818d-ab540865494b
# ╟─5e3f0741-fe66-4ccb-822f-63cda1b2c89b
# ╟─b5fb46e8-ff75-4eb1-ba63-92e3b4a764fe
# ╠═2670e66e-bc2a-11ed-2f25-c554deffd3bf
# ╟─4a77c84d-6a7b-4dd3-8701-ab405adb364b
# ╠═ee52bbc2-1e4a-47e4-8b43-8cb0e730069d
# ╟─206df737-3eb2-4275-861a-a0ba958c23d1
# ╠═d3e62a10-69ef-47c3-8ab3-4d1299bbfc82
# ╠═82b5c025-9ae1-461e-bf88-c6be0ed093f7
# ╟─36a0f36a-1d3f-40c8-8514-7a94ad7ea5c9
# ╠═ab0a8204-65ee-459d-98be-6087187b4096
# ╟─6a673be9-c6c0-4dce-b970-74f3e68fc990
# ╠═a2642146-a331-48a2-9a6c-850b3debe241
# ╠═0e1005c7-47b7-493f-99e6-be069e944c8b
# ╟─829b05e4-df24-46ed-981a-2bee358ae0aa
# ╟─d0ba43bc-18e4-4ccc-aa9d-d83285ea59b2
# ╠═8839cc30-2d1d-4c43-bccf-82944ee2a166
# ╠═e5e40188-08df-4b82-a776-86e645f925ff
# ╠═56d09724-e48f-4003-a168-0ef2e000e2ec
# ╠═5c285f77-31e6-4636-8702-7e99ed173491
# ╠═b07ded7a-21fb-4bcf-a4a7-96d6c73a0ee8
# ╠═3a93cb87-6e17-4fe4-a87c-db3ceb1a9fb8
# ╠═7d3b7168-ceea-484a-831b-dbf53dd3ac10
# ╠═61e583f4-b9f9-4727-bd0c-07360382cbf6
# ╟─47c9d5a3-274b-4612-a835-db3fadd3373e
# ╠═861d9a43-24c9-4cec-b82f-94a1b547c5b8
# ╠═7ba55f3d-509f-41a8-af58-95f3293ebe96
# ╠═e7a16f12-4d98-4caf-9161-31035d971ec3
# ╠═e6fffc89-420d-40af-b9ab-d23a56a72bf3
# ╠═3738164e-73d3-4b13-8386-26d1dfca3983
# ╟─bd0267c5-2047-43e4-851e-dadfc25d1ed9
# ╠═8322a1cf-0236-49b3-a169-f8ae7b4eedb7
# ╠═434211b7-1055-47d2-aa44-b4b2d9f97203
# ╠═be349102-60fc-4d27-aa5a-f1f74a96109b
# ╟─05d88bce-6bf7-415c-bee1-a45f8eeb0b34
# ╠═96b1616b-9ea6-4a11-b4b2-9a4464c36ab9
# ╠═f2d04cda-df53-4867-ac56-f597267cc807
# ╠═be1208cb-1621-469a-b41a-d7411f66e91d
# ╟─947d4c14-dd06-41ba-9edf-e09b9c55aacb
# ╠═a9aa8aec-c265-4bf9-9b15-1c810cbb0b7e
# ╠═087e4786-a933-47df-8526-60d20df63271
# ╠═54f9bed6-37f0-4b9e-901c-f4c5fb9ca2ba
# ╠═bdf9341c-ec26-423e-985d-834903c2eac0
# ╠═af31d1d7-ae8e-4400-aeb4-cb42ce0c4ec7
# ╟─8eec5baf-02a8-4414-a761-37612bbccae9
# ╠═104438b2-1ad4-4ec8-89eb-e5c0b3225525
# ╠═ec968447-7496-42c4-b5b7-5fda3e899e29
# ╠═8c9cfbd2-96e1-4d76-9b09-a5c35e5a5e17
# ╠═4bf453fe-97a2-4f28-ad46-f10eb253cc8b
# ╠═d9b1b5b9-3415-4fcf-96c7-e22628e51e4c
# ╟─0e4afe65-a002-48b0-9206-8f9e36954dff
# ╠═56dfc572-3a75-4846-bb41-811c4ddb42f8
# ╠═fdb173ff-2aea-443d-a99b-ed5f95279edb
# ╠═9f7e6763-e2ef-424e-8dee-0aebf3f74816
# ╠═d40c697d-89d2-4194-974e-ef778baa5d7b
# ╠═7b48451a-028c-48a4-ba9e-5975cbd656d4
# ╠═cf94afa3-779d-4c4e-bd24-2e86d923d337
# ╠═c5ccea9d-1a5f-4a9c-8424-5904532b35af
# ╠═01f7a94b-1b4d-4731-8185-7f894263ce1f
# ╠═9804906f-8489-4185-abad-0064bd1c610d
# ╠═2ed31d97-6e9d-4bf6-8bdb-2afb2bb4a776
# ╠═ba0bb57a-6a7b-47dd-844c-204ed0e0aec7
# ╠═295f2954-498b-4df3-8ef6-f7b3f427f08b
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
