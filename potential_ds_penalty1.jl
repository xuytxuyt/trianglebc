using Revise, TOML, ApproxOperator

config = TOML.parsefile("./toml/ds_penalty.toml")
elements,nodes = importmsh("./msh/square_1.msh",config)

ApproxOperator.set๐_DB!(elements["ฮฉ_"],:SegGI5)
set_memory_๐ญ!(elements["ฮฉ_"],:๐ญ)
set๐ญ!(elements["ฮฉ_"])
elements["ฮฉ_"][1].๐[1].๐ค=0.
elements["ฮฉ_"][1].๐[4].๐ค=0.
elements["ฮฉ_"][1].๐[7].๐ค=0.
elements["ฮฉ_"][1].๐[10].๐ค=0.
elements["ฮฉ_"][1].๐[13].๐ค=0.
elements["ฮฉ_"][2].๐[3].๐ค=0.
elements["ฮฉ_"][2].๐[6].๐ค=0.
elements["ฮฉ_"][2].๐[9].๐ค=0.
elements["ฮฉ_"][2].๐[12].๐ค=0.
elements["ฮฉ_"][2].๐[15].๐ค=0.

# elements["ฮฉ_"][1].๐[2].๐ค=0.
# elements["ฮฉ_"][1].๐[3].๐ค=0.
# elements["ฮฉ_"][1].๐[5].๐ค=0.
# elements["ฮฉ_"][1].๐[6].๐ค=0.
# elements["ฮฉ_"][1].๐[8].๐ค=0.
# elements["ฮฉ_"][1].๐[9].๐ค=0.
# elements["ฮฉ_"][1].๐[11].๐ค=0.
# elements["ฮฉ_"][1].๐[12].๐ค=0.
# elements["ฮฉ_"][1].๐[14].๐ค=0.
# elements["ฮฉ_"][1].๐[15].๐ค=0.
# elements["ฮฉ_"][2].๐[1].๐ค=0.
# elements["ฮฉ_"][2].๐[2].๐ค=0.
# elements["ฮฉ_"][2].๐[4].๐ค=0.
# elements["ฮฉ_"][2].๐[5].๐ค=0.
# elements["ฮฉ_"][2].๐[7].๐ค=0.
# elements["ฮฉ_"][2].๐[8].๐ค=0.
# elements["ฮฉ_"][2].๐[10].๐ค=0.
# elements["ฮฉ_"][2].๐[11].๐ค=0.
# elements["ฮฉ_"][2].๐[13].๐ค=0.
# elements["ฮฉ_"][2].๐[14].๐ค=0.

nโ = getnโ(elements["ฮฉ"])

set๐ญ!(elements["ฮฉ"])
setโ๐ญ!(elements["ฮฉ"])
set๐ญ!(elements["ฮแต"])

# prescribing
r = 5
u(x,y,z) = (x+y)^r
โuโx(x,y,z) = r*(x+y)^abs(r-1)
โuโy(x,y,z) = r*(x+y)^abs(r-1)
โยฒuโxยฒ(x,y,z) = r*(r-1)*(x+y)^abs(r-2)
โยฒuโyยฒ(x,y,z) = r*(r-1)*(x+y)^abs(r-2)
t(x,y,z,nโ,nโ) = โuโx(x,y,z)*nโ+โuโy(x,y,z)*nโ
b(x,y,z) = -(โยฒuโxยฒ(x,y,z)+โยฒuโyยฒ(x,y,z))
uฬ(x,y,z,nโ,nโ) = sign(nโ+nโ)*(x+y)^r

prescribe!(elements["ฮฉ"],:b=>b)
prescribe!(elements["ฮแต"],:g=>u)
prescribe!(elements["ฮแต"],:u=>uฬ)
prescribe!(elements["โฮฉ"],:u=>u)
prescribe!(elements["ฮฉ_"],:g=>u)

ops = [
    Operator{:โซโซโvโudxdy}(:k=>1.0),
    Operator{:โซvbdฮฉ}(),
    Operator{:โซvtdฮ}(),
    Operator{:โซvgdฮ}(:ฮฑ=>1e0),
    Operator{:Hโ}(),
    Operator{:โซudฮ}(),
    Operator{:โซvudฮ}(:ฮฑ=>1e9),
    Operator{:๐๐ฃ}()
]

k = zeros(nโ,nโ)
f = zeros(nโ)

# ops[1](elements["ฮฉ"],k)
# ops[2](elements["ฮฉ"],f)
ops[4](elements["ฮแต"],k,f)
# ops[7](elements["ฮฉ_"],k,f)
# ops[8](elements["ฮแต"],f)

d = k\f
# push!(getfield(nodes[1],:data),:d=>(2,d))

dex = ops[6](elements["โฮฉ"])

d-dex
# f
# prescribe!(elements["ฮฉ"],:u=>u)
# prescribe!(elements["ฮฉ"],:โuโx=>โuโx)
# prescribe!(elements["ฮฉ"],:โuโy=>โuโy)
# Hโ,Lโ = ops[5](elements["ฮฉ"])
