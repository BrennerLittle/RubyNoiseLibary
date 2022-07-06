def rawnoise(n)
    n = (n << 13) ^ n;
    return (1.0 - ((n * (n * n * 15731 + 789221) + 1376312589) & 0x7fffffff) / 1073741824.0);
    end
    def noise1d(x, octave, seed)
    return rawnoise(x * 1619 + octave * 3463 + seed * 13397);
    end
    def noise2d(x, y, octave, seed)
    return rawnoise(x * 1619 + y * 31337 + octave * 3463 + seed * 13397)
    end
    def noise3d(x, y, z, octave, seed)
    return rawnoise(x * 1919 + y * 31337 + z * 7669 + octave * 3463 + seed * 13397)
    end
    def interpolate(a, b, x)
    f = (1 - Math.cos(x * 3.141593)) * 0.5
    return a * (1 - f) + b * f
    end
    def smooth1d(x, octave, seed)
    intx = x.to_i
    fracx = x - intx;
    v1 = noise1d(intx, octave, seed)
    v2 = noise1d(intx + 1, octave, seed)
    return interpolate(v1, v2, fracx)
    end
    def smooth2d(x, y, octave, seed)
    intx = x.to_i
    fracx = x - intx;
    inty = y.to_i
    fracy = y - inty;
    v1 = noise2d(intx, inty, octave, seed);
    v2 = noise2d(intx + 1, inty, octave, seed);
    v3 = noise2d(intx, inty + 1, octave, seed);
    v4 = noise2d(intx + 1, inty + 1, octave, seed);
    i1 = interpolate(v1, v2, fracx);
    i2 = interpolate(v3, v4, fracx);
    return interpolate(i1, i2, fracy);
    end
    def smooth3d(x, y, z, octave, seed)
    intx = x.to_i
    fracx = x - intx;
    inty = y.to_i;
    fracy = y - inty;
    intz = z.to_i;
    fracz = z - intz;
    v1 = noise3d(intx, inty, intz, octave, seed);
    v2 = noise3d(intx + 1, inty, intz, octave, seed);
    v3 = noise3d(intx, inty + 1, intz, octave, seed);
    v4 = noise3d(intx + 1, inty + 1, intz, octave, seed);
    v5 = noise3d(intx, inty, intz + 1, octave, seed);
    v6 = noise3d(intx + 1, inty, intz + 1, octave, seed);
    v7 = noise3d(intx, inty + 1, intz + 1, octave, seed);
    v8 = noise3d(intx + 1, inty + 1, intz + 1, octave, seed);
    i1 = interpolate(v1, v2, fracx);
    i2 = interpolate(v3, v4, fracx);
    i3 = interpolate(v5, v6, fracx);
    i4 = interpolate(v7, v8, fracx);
    j1 = interpolate(i1, i2, fracy);
    j2 = interpolate(i3, i4, fracy);
    return interpolate(j1, j2, fracz);
    end
    def pnoise1d(x, persistence, octaves, seed)
        total = 0.0
        frequency = 1.0;
        amplitude = 1.0;
        i = 0;
        for i in i..octaves do total += smooth1d(x * frequency, i, seed) * amplitude;
          frequency /= 2;
        amplitude *= persistence;
        end
        return total;
        end
        def pnoise2d(x, y, persistence, octaves, seed)
        total = 0.0;
        frequency = 1.0;
        amplitude = 1.0;
        i = 0;
        for i in i..octaves do total += smooth2d(x * frequency, y * frequency, i, seed) * amplitude;
          frequency /= 2;
        amplitude *= persistence;
        end
        return total;
        end
        def pnoise3d(x, y, z, persistence, octaves, seed)
        total = 0.0;
        frequency = 1.0;
        amplitude = 1.0;
        i = 0;
        for i in i..octaves do total += smooth3d(x * frequency, y * frequency, z * frequency, i, seed) * amplitude;
          frequency /= 2;
        amplitude *= persistence;
        end
        return total;
        end