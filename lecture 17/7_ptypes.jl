### A Pluto.jl notebook ###
# v0.20.20

using Markdown
using InteractiveUtils

# ╔═╡ e248ec9e-7b3c-11ef-3434-b1e6fc44ac3b
using PlutoUI

# ╔═╡ cb79cfad-9b8c-4017-ba7c-9cebcebc84f7
TableOfContents(title="📚 Table of Contents", indent=true, depth=4, aside=true)

# ╔═╡ 144c7859-9880-4d8a-af4a-3f0d4e77bc46
md"""
# 1. Views (Performance)
"""

# ╔═╡ 2b0b302c-f474-4964-b88b-e182057cd5db
M = rand([2,3,5,7,9],3,3)

# ╔═╡ 9d6f60eb-7af4-4986-8946-e5a08868fda4
A = view(M, 2:3, 1:2)

# ╔═╡ 53ffeb7e-3e60-4c2f-b34a-984a7a7fb2df
md"""
# 2. Create a type, what methods are created?
"""

# ╔═╡ fe8b88e1-05fb-4387-8b04-c329ff4c46f3
struct C25
	value::Float64
end

# ╔═╡ 484b9cd9-2820-471b-85d3-75f23bbd9b61
C25(1.0)

# ╔═╡ 61dbdaaa-cc20-4bc9-a80c-5f4b9be1536a
md"""
Note that this **constructor** (a function with the same name as the type that creates objects of that type) was **automatically generated** when we defined the type. We can ask Julia which of these so-called default constructors are provided:
"""

# ╔═╡ 042e554c-59f7-4107-b958-76adcfcb8800
display(methods(C25))

# ╔═╡ 4f9f2a79-98e3-4244-81c0-6ad089c1ec57
C25(true)

# ╔═╡ 64fc97fa-897a-4b03-81ad-e5121c3ccf00
C25("Philip")

# ╔═╡ 6d46a963-d316-4b95-82a0-a8c8a3f3a050
convert(Float64, true)

# ╔═╡ 8f6f438d-a2b7-4eb0-b527-cf75e7741418
C25("3.1")

# ╔═╡ ce9fcfb2-9ab0-445f-beea-907c83a5b88b
convert(Float64, "3.1")

# ╔═╡ 9c1240da-86e8-4b27-9a49-ec56c632b725
parse(Float64,"3.1")

# ╔═╡ d27918d5-363a-49c7-a358-5265d35244ab
md"""
# 3. convert and Type{T} type selectors
"""

# ╔═╡ 06df76cc-8c6f-4997-b7f0-8bd475f2fa7d
md"""
You can define your own convert
"""


# ╔═╡ 406b2aab-a2ea-4540-9f2a-06f2513095b5
# Base.convert(::Type{Float64}, s::String) = parse(Float64, s)

# ╔═╡ 77349ae4-6c57-40d5-91b1-db353c7f2ddb
md"""
::Type{Float64}
means that the second argument s is a string and the first argument is not a Float64 but is itself a type. See  doc on [ Type{T} type selectors] (https://docs.julialang.org/en/v1/manual/types/#man-typet-type).
"""

# ╔═╡ f176edcc-de5e-4cd0-b6dd-428ce3ca302c
begin
  h1(::String, s::String) = s
  h2(T::Type{String}, s::String) = T  
  h3(T::Type{Number}, s::String) = T 
end

# ╔═╡ 0d8857b7-747a-4415-b505-aaa3c9110027
h1("abc","def")

# ╔═╡ 5eed423a-c0fb-449c-a3cc-6ed4f4e7ae7f
h2(String,"def")

# ╔═╡ fdc2102a-b25a-431e-ba9e-827898b0a421
h3(Number,"def")

# ╔═╡ c8c00b27-1467-4119-b9c5-3a4050adb047
isa(3.0, Float64)

# ╔═╡ 29f0fa70-715e-450b-8f24-b83d00399240
isa(Float64,Type{Float64})

# ╔═╡ 67a7ac4f-89cb-4fb1-99b5-23c7efae24e8
Type{Float64} <: DataType

# ╔═╡ f22b8320-1751-4920-995e-3dd762f1d884
md"""
# 4. getfield
"""

# ╔═╡ 3049e587-c25b-4926-8aa1-cf3781a1e642
fieldnames( C25 )

# ╔═╡ 55d8bbc7-5d0e-495a-b371-34cffb9d4884
C25(3).value

# ╔═╡ a35181c6-5040-4cbb-9cb0-643c2a5b8593
getfield(C25(3),:value)

# ╔═╡ 13237b9e-edc6-4288-a51f-146b3e3d5252
getfield(C25(3),1)

# ╔═╡ f1e944fe-e8ee-47ca-bdb8-ffff8c245cdd
md"""
# 5. constructors with conditions
"""

# ╔═╡ 1a57c6a7-105e-4bed-acd4-0c4250d410f9
md"""
In this example, we also illustrate [short circuit evaluation](https://docs.julialang.org/en/v1/manual/control-flow/#Short-Circuit-Evaluation)

Here we have used so-called "short-circuit" evaluation: && can be thought of as an if...then, while || is unless... (i.e. if not ... then).
"""

# ╔═╡ ac317618-c293-41cf-a5de-a123b1674e7f
struct C25v2
    value::Float64
    
    function C25v2(x)
    
        x < 0 && throw(ArgumentError("Negative value not allowed."))
        
        new(x)
    end
end

# ╔═╡ 31fd9ece-a5c2-4072-b1ef-3d33268dc678
C25v2(-1)

# ╔═╡ a7d8ce7b-50db-4503-972f-0b0e17e340ee
md"""
# 6. What if we don't want to nail down the type?
"""

# ╔═╡ 9f20ba44-658a-42d3-8baa-e25b4a4d86b0
md"""
sometimes it's okay to do this, but one can do better
"""

# ╔═╡ a78c8fbf-5555-4f10-9491-5f2af68c632e
struct C25v3
	v
end

# ╔═╡ 93f6dacc-ebc8-4d0b-ab5f-10c9ec395a2d
md"""
# 7. Parametric Types
"""

# ╔═╡ b6b34a07-ffb1-4f62-8b71-3f6fb56f11fa
struct C25v4{T}
	v::T
end

# ╔═╡ dab97bb1-aec9-4ff7-8e20-24725be751c5
C25v4(3)

# ╔═╡ 0720bbc9-c47a-4dcf-b43d-27c06354cdc2
C25v4(2.54)

# ╔═╡ b2d48852-3ec7-4e5c-8363-b7325ae895fe
C25v4( rand(3,3))

# ╔═╡ 3e09c429-4daf-4bc0-92fa-97ef43dbaf68
C25v4( C25v4(7))

# ╔═╡ e4bb130f-9e98-4afe-85e8-38f7483b62db
md"""
# 8. Adding Conditions to types
"""

# ╔═╡ 0d789338-f2b9-4765-a7e9-d33ee416f560
struct C25v5{ T<:Real }
	v::T
end

# ╔═╡ af52a273-c1bc-46af-a0a3-ff826b324cd6
C25v5(3)

# ╔═╡ e65b158d-7c54-4b9c-895b-cdaaadde20ee
C25v5("hello")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.60"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.4"
manifest_format = "2.0"
project_hash = "c1674f662899f5bfc062df83020732df21a649e9"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

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

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+4"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eba4810d5e6a01f612b948c9fa94f905b49087b0"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.60"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

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

[[deps.Tricks]]
git-tree-sha1 = "7822b97e99a1672bfb1b49b668a6d46d58d8cbcb"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.9"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╠═e248ec9e-7b3c-11ef-3434-b1e6fc44ac3b
# ╠═cb79cfad-9b8c-4017-ba7c-9cebcebc84f7
# ╠═144c7859-9880-4d8a-af4a-3f0d4e77bc46
# ╠═2b0b302c-f474-4964-b88b-e182057cd5db
# ╠═9d6f60eb-7af4-4986-8946-e5a08868fda4
# ╟─53ffeb7e-3e60-4c2f-b34a-984a7a7fb2df
# ╠═fe8b88e1-05fb-4387-8b04-c329ff4c46f3
# ╠═484b9cd9-2820-471b-85d3-75f23bbd9b61
# ╟─61dbdaaa-cc20-4bc9-a80c-5f4b9be1536a
# ╠═042e554c-59f7-4107-b958-76adcfcb8800
# ╠═4f9f2a79-98e3-4244-81c0-6ad089c1ec57
# ╠═64fc97fa-897a-4b03-81ad-e5121c3ccf00
# ╠═6d46a963-d316-4b95-82a0-a8c8a3f3a050
# ╠═8f6f438d-a2b7-4eb0-b527-cf75e7741418
# ╠═ce9fcfb2-9ab0-445f-beea-907c83a5b88b
# ╠═9c1240da-86e8-4b27-9a49-ec56c632b725
# ╟─d27918d5-363a-49c7-a358-5265d35244ab
# ╟─06df76cc-8c6f-4997-b7f0-8bd475f2fa7d
# ╠═406b2aab-a2ea-4540-9f2a-06f2513095b5
# ╟─77349ae4-6c57-40d5-91b1-db353c7f2ddb
# ╠═f176edcc-de5e-4cd0-b6dd-428ce3ca302c
# ╠═0d8857b7-747a-4415-b505-aaa3c9110027
# ╠═5eed423a-c0fb-449c-a3cc-6ed4f4e7ae7f
# ╠═fdc2102a-b25a-431e-ba9e-827898b0a421
# ╠═c8c00b27-1467-4119-b9c5-3a4050adb047
# ╠═29f0fa70-715e-450b-8f24-b83d00399240
# ╠═67a7ac4f-89cb-4fb1-99b5-23c7efae24e8
# ╟─f22b8320-1751-4920-995e-3dd762f1d884
# ╠═3049e587-c25b-4926-8aa1-cf3781a1e642
# ╠═55d8bbc7-5d0e-495a-b371-34cffb9d4884
# ╠═a35181c6-5040-4cbb-9cb0-643c2a5b8593
# ╠═13237b9e-edc6-4288-a51f-146b3e3d5252
# ╠═f1e944fe-e8ee-47ca-bdb8-ffff8c245cdd
# ╟─1a57c6a7-105e-4bed-acd4-0c4250d410f9
# ╠═ac317618-c293-41cf-a5de-a123b1674e7f
# ╠═31fd9ece-a5c2-4072-b1ef-3d33268dc678
# ╟─a7d8ce7b-50db-4503-972f-0b0e17e340ee
# ╟─9f20ba44-658a-42d3-8baa-e25b4a4d86b0
# ╠═a78c8fbf-5555-4f10-9491-5f2af68c632e
# ╟─93f6dacc-ebc8-4d0b-ab5f-10c9ec395a2d
# ╠═b6b34a07-ffb1-4f62-8b71-3f6fb56f11fa
# ╠═dab97bb1-aec9-4ff7-8e20-24725be751c5
# ╠═0720bbc9-c47a-4dcf-b43d-27c06354cdc2
# ╠═b2d48852-3ec7-4e5c-8363-b7325ae895fe
# ╠═3e09c429-4daf-4bc0-92fa-97ef43dbaf68
# ╟─e4bb130f-9e98-4afe-85e8-38f7483b62db
# ╠═0d789338-f2b9-4765-a7e9-d33ee416f560
# ╠═af52a273-c1bc-46af-a0a3-ff826b324cd6
# ╠═e65b158d-7c54-4b9c-895b-cdaaadde20ee
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
