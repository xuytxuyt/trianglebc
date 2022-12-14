using Revise, TOML, ApproxOperator

config = TOML.parsefile("./toml/ds_lm.toml")
elements,nodes = importmsh("./msh/square_1.msh",config)

ApproxOperator.set๐_DB!(elements["ฮ"],:SegGI5)
set_memory_๐ญ!(elements["ฮ"],:๐ญ,:๐ญฬ)
set๐ญ!(elements["ฮ"])
set๐ญฬ!(elements["ฮ"])
set_memory_๐ญ!(elements["ฮแต"],:๐ญ,:๐ญฬ)
set๐ญ!(elements["ฮแต"])
set๐ญฬ!(elements["ฮแต"])

# elements["ฮ"][1].๐[1].๐ค=0.
# elements["ฮ"][1].๐[4].๐ค=0.
# elements["ฮ"][1].๐[7].๐ค=0.
# elements["ฮ"][1].๐[10].๐ค=0.
# elements["ฮ"][1].๐[13].๐ค=0.
# elements["ฮ"][2].๐[3].๐ค=0.
# elements["ฮ"][2].๐[6].๐ค=0.
# elements["ฮ"][2].๐[9].๐ค=0.
# elements["ฮ"][2].๐[12].๐ค=0.
# elements["ฮ"][2].๐[15].๐ค=0.

# elements["ฮ"][1].๐[2].๐ค=0.
# elements["ฮ"][1].๐[3].๐ค=0.
# elements["ฮ"][1].๐[5].๐ค=0.
# elements["ฮ"][1].๐[6].๐ค=0.
# elements["ฮ"][1].๐[8].๐ค=0.
# elements["ฮ"][1].๐[9].๐ค=0.
# elements["ฮ"][1].๐[11].๐ค=0.
# elements["ฮ"][1].๐[12].๐ค=0.
# elements["ฮ"][1].๐[14].๐ค=0.
# elements["ฮ"][1].๐[15].๐ค=0.
# elements["ฮ"][2].๐[1].๐ค=0.
# elements["ฮ"][2].๐[2].๐ค=0.
# elements["ฮ"][2].๐[4].๐ค=0.
# elements["ฮ"][2].๐[5].๐ค=0.
# elements["ฮ"][2].๐[7].๐ค=0.
# elements["ฮ"][2].๐[8].๐ค=0.
# elements["ฮ"][2].๐[10].๐ค=0.
# elements["ฮ"][2].๐[11].๐ค=0.
# elements["ฮ"][2].๐[13].๐ค=0.
# elements["ฮ"][2].๐[14].๐ค=0.

nโ = getnโ(elements["ฮฉ"])

set๐ญ!(elements["ฮฉ"])
setโ๐ญ!(elements["ฮฉ"])

# prescribing
r = 3
u(x,y,z) = (x+y)^r
โuโx(x,y,z) = r*(x+y)^abs(r-1)
โuโy(x,y,z) = r*(x+y)^abs(r-1)
โยฒuโxยฒ(x,y,z) = r*(r-1)*(x+y)^abs(r-2)
โยฒuโyยฒ(x,y,z) = r*(r-1)*(x+y)^abs(r-2)
t(x,y,z,nโ,nโ) = โuโx(x,y,z)*nโ+โuโy(x,y,z)*nโ
b(x,y,z) = -(โยฒuโxยฒ(x,y,z)+โยฒuโyยฒ(x,y,z))
uฬ(x,y,z,nโ,nโ) = sign(nโ+nโ)*(x+y)^r

prescribe!(elements["ฮฉ"],:b=>b)
# prescribe!(elements["ฮแต"],:u=>uฬ)
prescribe!(elements["ฮแต"],:g=>u)
prescribe!(elements["โฮฉ"],:u=>u)

ops = [
    Operator{:โซโซโvโudxdy}(:k=>1.0),
    Operator{:โซvbdฮฉ}(),
    Operator{:โซuฮปdฮ}(),
    Operator{:๐๐ฃ}(),
    Operator{:Hโ}(),
    Operator{:โซudฮ}(),
    Operator{:โซvgdฮ}(:ฮฑ=>1e9),
    Operator{:โซuฮปฬdฮ}()
]

k = zeros(nโ,nโ)
f = zeros(nโ)
g = zeros(nโ,8)
q = zeros(8)

ops[1](elements["ฮฉ"],k)
ops[2](elements["ฮฉ"],f)
# ops[3](elements["ฮ"],g)
# ops[4](elements["ฮแต"],q)
# ops[4](elements["โฮฉ"][2],k,f)
# ops[7](elements["ฮแต"],k,f)
# ops[8](elements["ฮ"],g)

op_ฮ = Operator{:โซsแตขnแตขudฮ}()
op_ฮ(elements["ฮ"],g)
op_ฮแต = Operator{:โซsแตขnแตขgdฮ}()
op_ฮแต(elements["ฮแต"],q)

d = [k g;g' zeros(8,8)]\[f;q]
# d = k\f
# d_ = [k g[:,[2,4]];g[:,[2,4]]' zeros(2,2)]\[f;zeros(2)]
push!(getfield(nodes[1],:data),:d=>(2,d))

op_ex = Operator{:โซudฮ}()
dex = op_ex(elements["โฮฉ"])

# d[1:5] - dex
# prescribe!(elements["ฮฉ"],:u=>u)
# prescribe!(elements["ฮฉ"],:โuโx=>โuโx)
# prescribe!(elements["ฮฉ"],:โuโy=>โuโy)
# Hโ,Lโ = ops[5](elements["ฮฉ"])
