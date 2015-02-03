# From https://gist.github.com/idlewan/ab53b761ab1522251682
import os, strutils, math

const SOLAR_MASS = 4'f64 * PI * PI
const DAYS_PER_YEAR = 365.24'f64

type Planet = tuple[
    x, y, z: float64,
    dump: float64,
    vx, vy, vz: float64,
    mass: float64
]

var bodies: array[0..4, Planet] = [
    # sun
    (0'f64, 0'f64, 0'f64,
     0'f64,
     0'f64, 0'f64, 0'f64, SOLAR_MASS),

    # jupiter
    (4.84143144246472090e+00'f64,
    -1.16032004402742839e+00'f64,
    -1.03622044471123109e-01'f64,
     0'f64,
     1.66007664274403694e-03'f64 * DAYS_PER_YEAR,
     7.69901118419740425e-03'f64 * DAYS_PER_YEAR,
    -6.90460016972063023e-05'f64 * DAYS_PER_YEAR,
     9.54791938424326609e-04'f64 * SOLAR_MASS),

     # saturn
    (8.34336671824457987e+00'f64,
     4.12479856412430479e+00'f64,
    -4.03523417114321381e-01'f64,
     0'f64,
    -2.76742510726862411e-03'f64 * DAYS_PER_YEAR,
     4.99852801234917238e-03'f64 * DAYS_PER_YEAR,
     2.30417297573763929e-05'f64 * DAYS_PER_YEAR,
     2.85885980666130812e-04'f64 * SOLAR_MASS),

     # uranus
    (1.28943695621391310e+01'f64,
    -1.51111514016986312e+01'f64,
    -2.23307578892655734e-01'f64,
     0'f64,
     2.96460137564761618e-03'f64 * DAYS_PER_YEAR,
     2.37847173959480950e-03'f64 * DAYS_PER_YEAR,
    -2.96589568540237556e-05'f64 * DAYS_PER_YEAR,
     4.36624404335156298e-05'f64 * SOLAR_MASS),

     # neptune
    (1.53796971148509165e+01'f64,
    -2.59193146099879641e+01'f64,
     1.79258772950371181e-01'f64,
     0'f64,
     2.68067772490389322e-03'f64 * DAYS_PER_YEAR,
     1.62824170038242295e-03'f64 * DAYS_PER_YEAR,
    -9.51592254519715870e-05'f64 * DAYS_PER_YEAR,
     5.15138902046611451e-05'f64 * SOLAR_MASS)
]

proc advance(bodies: var array[0..4, Planet], dt: float64) =
    for i in 0 .. <bodies.len:
        var b = addr bodies[i]
        for j in i+1 .. <bodies.len:
            var b2 = addr bodies[j]
            let dx = b.x - b2.x
            let dy = b.y - b2.y
            let dz = b.z - b2.z
            let distance = sqrt(dx*dx + dy*dy + dz*dz)
            let mag = dt / (distance*distance*distance)
            b.vx -= dx * b2.mass * mag
            b.vy -= dy * b2.mass * mag
            b.vz -= dz * b2.mass * mag
            b2.vx += dx * b.mass * mag
            b2.vy += dy * b.mass * mag
            b2.vz += dz * b.mass * mag
    for i in 0 .. <bodies.len:
        var b = addr bodies[i]
        b.x += dt * b.vx
        b.y += dt * b.vy
        b.z += dt * b.vz

proc energy(bodies: var array[0..4, Planet]): float64 =
    for i, b in bodies:
        result += 0.5 * b.mass * (b.vx*b.vx + b.vy*b.vy + b.vz*b.vz)
        for j in i+1 .. <bodies.len:
            let b2 = bodies[j]
            let dx = b.x - b2.x
            let dy = b.y - b2.y
            let dz = b.z - b2.z
            let distance = sqrt(dx*dx + dy*dy + dz*dz)
            result -= b.mass * b2.mass / distance

proc offset_momentum(bodies: var array[0..4, Planet]) =
    var px, py, pz: float64
    for b in bodies:
        px += b.vx * b.mass
        py += b.vy * b.mass
        pz += b.vz * b.mass
    bodies[0].vx = -px / SOLAR_MASS
    bodies[0].vy = -py / SOLAR_MASS
    bodies[0].vz = -pz / SOLAR_MASS


var n = 1_000_000
if paramCount() > 0:
    n = paramStr(1).parseInt

offset_momentum(bodies)
echo formatFloat(energy(bodies), precision=9)
for i in 1 .. n:
    advance(bodies, 0.01)
echo formatFloat(energy(bodies), precision=9)
