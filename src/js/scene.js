class Scene {
    camera = {
        origin: { x: 50.0, y: 40.8, z: 220.0 },
        lookAt: { x: 50.0, y: 40.8, z: 0.0 },
        fieldOfView: 40.0,
    };

    spheres = [
        {
            center: { x: 10.0, y: 70.0, z: 51.6 },
            radius: 6.0,
            color: { r: 31.8309886184, g: 31.8309886184, b: 31.8309886184 },
        },
        {
            center: { x: 10001.0, y: 40.8, z: 81.6 },
            radius: 10000.0,
            color: { r: 0.75, g: 0.25, b: 0.25 },
        },
        {
            center: { x: -9901.0, y: 40.8, z: 81.6 },
            radius: 10000.0,
            color: { r: 0.25, g: 0.25, b: 0.75 },
        },
        {
            center: { x: 50.0, y: 40.8, z: 10000.0 },
            radius: 10000.0,
            color: { r: 0.75, g: 0.65, b: 0.75 }
        },
        {
            center: { x: 50.0, y: 40.8, z: -9650.0 },
            radius: 10000,
            color: { r: 0.50, g: 0.50, b: 0.50 },
        },
        {
            center: { x: 50.0, y: 10000.0, z: 81.6 },
            radius: 10000,
            color: { r: 0.65, g: 0.75, b: 0.75 },
        },
        {
            center: { x: 50.0, y: -9918.4, z: 81.6 },
            radius: 10000,
            color: { r: 0.75, g: 0.75, b: 0.65 },
        },
        {
            center: { x: 50.0, y: 20.0, z: 50.0 },
            radius: 20.0,
            color: { r: 0.25, g: 0.75, b: 0.25 }
        },
        {
            center: { x: 19.0, y: 16.5, z: 25.0 },
            radius: 16.5,
            color: { r: 0.8, g: 0.8, b: 0.8 },
        },
        {
            center: { x: 77.0, y: 16.5, z: 78.0 },
            radius: 16.5,
            color: { r: 1.0, g: 1.0, b: 1.0 },
        },
    ];
}