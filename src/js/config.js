class Config {
    pathLog = {
        enabled: true,
        targetIndex: 902638,
    };

    bindGroup = {
        primary: {
            index: 0,
            binding: {
                camera: 0,
                sphere: 1,
                chain: 2,
                path: 3,
                image: 4,
                queue: 5,
                pathLog: 6,
            },
        },
        auxiliary: {
            index: 1,
            binding: {
                dispatchIndirectParameters: 0,
            },
        },
        uniform: {
            index: 2,
            binding: {
                parameters: 0,
            },
        },
    };

    random = {
        counts: {
            vertex: 4,
        },
    };

    path = {
        count: 1_000_000,
        length: {
            min: 2,
            max: 6,
        },
    };

    queue = {
        count: 11,
        index: {
            sample: {
                camera: 0,
                light: 1,
                material: 2,
            },
            intersect: 3,
            connect: 4,
            postConnect: {
                camera: {
                    direct: 5,
                    indirect: 6,
                },
                light: {
                    direct: 7,
                    indirect: 8,
                },
                null: 9,
            },
            contribute: 10,
        },
    };

    sphere = {
        count: 10,
        id: {
            light: 0,
        },
    };

    workgroup = {
        size: 64,
    };

    image = {
        width: 640,
        height: 480,
    };
    
    memory = {
        limit: 2_147_483_644,
    };
}