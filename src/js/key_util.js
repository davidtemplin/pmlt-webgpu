class KeyUtil {
    static parse(key) {
        const hi = parseInt(key.substring(2, 10), 16);
        const lo = parseInt(key.substring(10), 16);
        return { hi, lo };
    }
}