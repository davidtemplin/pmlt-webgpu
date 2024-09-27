class VectorMath {
    static norm(v) {
        let n = Math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z);
        return { x: v.x / n, y: v.y / n, z: v.z / n};
    }
    
    static cross(a, b) {
        return {
            x: a.y * b.z - a.z * b.y,
            y: a.z * b.x - a.x * b.z,
            z: a.x * b.y - a.y * b.x,
        }
    }
    
    static isZero(v) {
        v.x == 0.0 && v.y == 0.0 && v.z == 0.0;
    }
    
    static orthonormalBasis(n) {
        const w = VectorMath.norm(n);
        const ey = { x: 0.0, y: 1.0, z: 0.0 };
        let u = VectorMath.norm(VectorMath.cross(ey, w));
        let v;
        if (VectorMath.isZero(u)) {
            const ex = { x: 1.0, y: 0.0, z: 0.0 };
            v = VectorMath.norm(VectorMath.cross(w, ex));
            u = VectorMath.norm(VectorMath.cross(v, w));
        } else {
            v = VectorMath.norm(VectorMath.cross(w, u));
        }
        return { u, v, w };
    }
    
    static sub(a, b) {
        return { x: a.x - b.x, y: a.y - b.y, z: a.z - b.z, };
    }
}