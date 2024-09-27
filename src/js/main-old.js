const keys = [
'0xc8e4fd154ce32f6d',
'0xfcbd6e154bf53ed9',
'0xea6342c76bf95d47',
'0xfb9e125878fa6cb3',
'0xa1ed294ba7fe8b31',
'0xcf29ba8dc5f1a98d',
'0x815a7d4ed4e3b7f9',
'0x163acbf213f5d867',
'0x674e2d1542f9e6d3',
'0xebc9672872ecf651',
'0xec13a6976ecf14ad',
'0x42c86e3a9de3542b',
'0x5489de2cbce65297',
'0x49bc37fdcad971f3',
'0xd5b4213fe7db8f61',
'0xbf785e3215ac7ebd',
'0x46be329546e1ad3b',
'0x8b7ef19654e3dca7',
'0x1d7683c983d7eb15',
'0x3724b1c872d9fa81',
'0x2af73db87fab18ed',
'0xa185f4cbadcf285b',
'0x53d684c1fbd246c7',
'0x35fda1821cd68735',
'0xfd3791543bd985a1',
'0x7f59c4b657cb941f',
'0x19f3e5b765cea27b',
'0xf6235eca95b2c1e7',
'0x9d827c5ba2b3df45',
'0x8a149e2dc2a6feb1',
'0xa9234cbdcea91d2f',
'0xab134cd21f9c2d8b',
'0x65c48e132c9e3bf7',
'0x7e943bd54dc26b75',
'0x4b3a29d76ab579d1',
'0xfa2871eba6b7984f',
'0x4bd2596ed48c96ab',
'0xa9463c1ed4aec629',
'0x39a5fc81f3b1e495',
'0x72f9c8a323a5e4f1',
'0xb7cf8a2652b8136f',
'0xb372ac465f8932db',
'0x16dab9f87ead5149',
'0xaf9ed4c87b8e4fa5',
'0xbcae598dcba48e13',
'0xd3bc94fed6948c7f',
'0xbacd24f1f4768aeb',
'0xfeca9382147acb59',
'0xf4a18b53237ed9c5',
'0xfa96251875a1f943',
'0xb247ef5982a4179f',
'0x695781dbaf98371d',
'0x782ae64dce8b3579',
'0xad5b918edb8c64e5',
'0x4e98ac3feb9f8463',
'0xd1bc48f21a7382bf',
'0xa763b9e54986a13d',
'0x9d3fe5643456bf89',
'0x7acf9b287369bdf5',
'0x7f4823ba926ced73',
'0x5acef64ba3721bcf',
'0x8af4673dcf752b4d',
'0x2bc59ae1fe563ab9',
'0xb639dc821e6b5a27',
'0x71d692e32c5d6893',
'0x8ec7d3f4394d76ef',
'0x6cf18d298972a56d',
'0xa1c698dba765b4d9',
'0x527f618dc569d347',
'0x167d892ed46ae2b3',
'0x63547dbfe47df231',
'0xf84de9565472318d',
'0xa8e4dc232d543fe9',
'0x89f56da76d384e57',
'0x42ea36b87b496dc3',
'0x17fd98ba9a5d8c41',
'0x763f529cb63f7a9d',
'0xe8794dcfe753c91b',
'0xd7e4f9c1f534d987',
'0x5fa74d621548d7e3',
'0x783c12e6534bf761',
'0xe7c435b8724e15bd',
'0xc1258b6a9f61453b',
'0xae842f6cbe2453a7',
'0x176f8e4dcd498315',
'0xc48512bfec4b9281',
'0x8bd269cfe62a7fcd',
'0x7fbe5932172f9e4b',
'0x34fa7d954632cdb7',
'0xad1b36598736ec25',
'0xc471f3598437fb91',
'0xfec831d9823a19fd',
'0x58f9746baf1e296b',
'0xeb6a512dce2148d7',
'0x635c9b81fd137845',
'0xe32f6dc43d2786b1',
'0x924ec7a54b1a952f',
'0x74af9cd6571da38b',
'0x3bc5d689861eb2f7',
'0xfb6da23cb823e175',
];

const constants = {
    cameraGroup: 0,
    cameraBinding: 0,
    sphereGroup: 0,
    sphereBinding: 1,
    chainGroup: 0,
    chainBinding: 2,
    pathStateGroup: 0,
    pathStateBinding: 3,
    imageGroup: 0,
    imageBinding: 4,
    queuesGroup: 0,
    queuesBinding: 5,
    queueCountsGroup: 0,
    queueCountsBinding: 6,
    dispatchIndirectParametersGroup: 1,
    dispatchIndirectParametersBinding: 0,
    uniformsGroup: 2,
    uniformsBinding: 0,
    workgroupSize: 64,
    maxPathLength: 5,
    pathCount: 1_000_000,
    lightSphereId: 0,
    sphereCount: 10,
    pixelWidth: 640,
    pixelHeight: 480,
    numbersPerVertex: 4,
    queueCount: 6,
    sampleCameraQueueId: 0,
    sampleLightQueueId: 1,
    intersectQueueId: 2,
    sampleMaterialQueueId: 3,
    connectQueueId: 4,
    contributeQueueId: 5,
};

const wgslLib = `#include lib.wgsl`;

const initializeModuleCode = `#include initialize.wgsl`;

const sampleCameraModuleCode = `#include sample_camera.wgsl`;

const sampleLightModuleCode = `#include sample_light.wgsl`;

const dispatchModuleCode = `#include dispatch.wgsl`;

const clearQueueModuleCode = `#include clear_queue.wgsl`;

const intersectModuleCode = `#include intersect.wgsl`;

const buildCdfModuleCode = `#include build_cdf.wgsl`;

const scene = {
    camera: {
        origin: { x: 50.0, y: 40.8, z: 220.0 },
        lookAt: { x: 50.0, y: 40.8, z: 0.0 },
        fieldOfView: 40.0,
    },
    spheres: [
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
    ],
};

function norm(v) {
    let n = Math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z);
    return { x: v.x / n, y: v.y / n, z: v.z / n};
}

function cross(a, b) {
    return {
        x: a.y * b.z - a.z * b.y,
        y: a.z * b.x - a.x * b.z,
        z: a.x * b.y - a.y * b.x,
    }
}

function isZero(v) {
    v.x == 0.0 && v.y == 0.0 && v.z == 0.0;
}

function orthonormalBasis(n) {
    const w = norm(n);
    const ey = { x: 0.0, y: 1.0, z: 0.0 };
    let u = norm(cross(ey, w));
    let v;
    if (isZero(u)) {
        const ex = { x: 1.0, y: 0.0, z: 0.0 };
        v = norm(cross(w, ex));
        u = norm(cross(v, w));
    } else {
        v = norm(cross(w, u));
    }
    return { u, v, w };
}

function sub(a, b) {
    return { x: a.x - b.x, y: a.y - b.y, z: a.z - b.z, };
}

function parseKey(key) {
    const hi = parseInt(key.substring(2, 10), 16);
    const lo = parseInt(key.substring(10), 16);
    return { hi, lo };
}

function getQueuesArrayViews(queuesArray) { 
    return [
        new Uint32Array(queuesArray, 0, constants.pathCount),
        new Uint32Array(queuesArray, 4 * constants.pathCount, constants.pathCount),
        new Uint32Array(queuesArray, 8 * constants.pathCount, constants.pathCount),
        new Uint32Array(queuesArray, 12 * constants.pathCount, constants.pathCount),
        new Uint32Array(queuesArray, 16 * constants.pathCount, constants.pathCount),
        new Uint32Array(queuesArray, 20 * constants.pathCount, constants.pathCount),
  ];
}

function getQueueCountsArrayViews(queueCountsArray) {
    return [new Uint32Array(queueCountsArray)];
}

function getCameraArrayViews(cameraArray) {
    return {
        u: new Float32Array(cameraArray, 0, 3),
        v: new Float32Array(cameraArray, 16, 3),
        w: new Float32Array(cameraArray, 32, 3),
        origin: new Float32Array(cameraArray, 48, 3),
        distance: new Float32Array(cameraArray, 60, 1),
    };
}

function getSphereArrayViews(sphereArray) {
    return {
        radius: new Float32Array(sphereArray, 0, scene.spheres.length),
        center_x: new Float32Array(sphereArray, 4 * scene.spheres.length, scene.spheres.length),
        center_y: new Float32Array(sphereArray, 8 * scene.spheres.length, scene.spheres.length),
        center_z: new Float32Array(sphereArray, 12 * scene.spheres.length, scene.spheres.length),
        color_r: new Float32Array(sphereArray, 16 * scene.spheres.length, scene.spheres.length),
        color_g: new Float32Array(sphereArray, 20 * scene.spheres.length, scene.spheres.length),
        color_b: new Float32Array(sphereArray, 24 * scene.spheres.length, scene.spheres.length),
    };
}

function getChainArrayViews(chainArray) {
    const chainCount = constants.maxPathLength - 1;
    return {
        key_hi: new Uint32Array(chainArray, 0, chainCount),
        key_lo: new Uint32Array(chainArray, 4 * chainCount, chainCount),
        iteration: new Uint32Array(chainArray, 8 * chainCount, chainCount),
        numbers_per_iteration: new Uint32Array(chainArray, 12 * chainCount, chainCount),
        numbers_per_path: new Uint32Array(chainArray, 16 * chainCount, chainCount),
        numbers_per_stream: new Uint32Array(chainArray, 20 * chainCount, chainCount),
        large_step_index_hi: new Uint32Array(chainArray, 24 * chainCount, chainCount),
        large_step_index_lo: new Uint32Array(chainArray, 28 * chainCount, chainCount),
        small_step_count: new Uint32Array(chainArray, 32 * chainCount, chainCount),
    };
}

function getPathStateArrayViews(pathStateArray) {
    return {
        step_type: new Uint32Array(pathStateArray, 0, constants.pathCount),
        local_path_index: new Uint32Array(pathStateArray, 4 * constants.pathCount, constants.pathCount),
        path_length: new Uint32Array(pathStateArray, 8 * constants.pathCount, constants.pathCount),
        vertex_index: new Uint32Array(pathStateArray, 12 * constants.pathCount, constants.pathCount),
        light_technique: new Uint32Array(pathStateArray, 16 * constants.pathCount, constants.pathCount),
        camera_technique: new Uint32Array(pathStateArray, 20 * constants.pathCount, constants.pathCount),
        ray_origin_x: new Float32Array(pathStateArray, 24 * constants.pathCount, constants.pathCount),
        ray_origin_y: new Float32Array(pathStateArray, 28 * constants.pathCount, constants.pathCount),
        ray_origin_z: new Float32Array(pathStateArray, 32 * constants.pathCount, constants.pathCount),
        ray_direction_x: new Float32Array(pathStateArray, 36 * constants.pathCount, constants.pathCount),
        ray_direction_y: new Float32Array(pathStateArray, 40 * constants.pathCount, constants.pathCount),
        ray_direction_z: new Float32Array(pathStateArray, 44 * constants.pathCount, constants.pathCount),
        contribution_r: new Float32Array(pathStateArray, 48 * constants.pathCount, constants.pathCount),
        contribution_g: new Float32Array(pathStateArray, 52 * constants.pathCount, constants.pathCount),
        contribution_b: new Float32Array(pathStateArray, 56 * constants.pathCount, constants.pathCount),
        scalar_contribution: new Float32Array(pathStateArray, 60 * constants.pathCount, constants.pathCount),
        point_x: [
          new Float32Array(pathStateArray, 64 * constants.pathCount, constants.pathCount),
          new Float32Array(pathStateArray, 68 * constants.pathCount, constants.pathCount),
        ],
        point_y: [
          new Float32Array(pathStateArray, 72 * constants.pathCount, constants.pathCount),
          new Float32Array(pathStateArray, 76 * constants.pathCount, constants.pathCount),
        ],
        point_z: [
          new Float32Array(pathStateArray, 80 * constants.pathCount, constants.pathCount),
          new Float32Array(pathStateArray, 84 * constants.pathCount, constants.pathCount),
        ],
        normal_x: [
          new Float32Array(pathStateArray, 88 * constants.pathCount, constants.pathCount),
          new Float32Array(pathStateArray, 92 * constants.pathCount, constants.pathCount),
        ],
        normal_y: [
          new Float32Array(pathStateArray, 96 * constants.pathCount, constants.pathCount),
          new Float32Array(pathStateArray, 100 * constants.pathCount, constants.pathCount),
        ],
        normal_z: [
          new Float32Array(pathStateArray, 104 * constants.pathCount, constants.pathCount),
          new Float32Array(pathStateArray, 108 * constants.pathCount, constants.pathCount),
        ],
        wo_x: [
          new Float32Array(pathStateArray, 112 * constants.pathCount, constants.pathCount),
          new Float32Array(pathStateArray, 116 * constants.pathCount, constants.pathCount),
        ],
        wo_y: [
          new Float32Array(pathStateArray, 120 * constants.pathCount, constants.pathCount),
          new Float32Array(pathStateArray, 124 * constants.pathCount, constants.pathCount),
        ],
        wo_z: [
          new Float32Array(pathStateArray, 128 * constants.pathCount, constants.pathCount),
          new Float32Array(pathStateArray, 132 * constants.pathCount, constants.pathCount),
        ],
        sphere_id: [
          new Float32Array(pathStateArray, 136 * constants.pathCount, constants.pathCount),
          new Float32Array(pathStateArray, 140 * constants.pathCount, constants.pathCount),
        ],
        pdf_fwd: [
          [
            new Float32Array(pathStateArray, 144 * constants.pathCount, constants.pathCount),
            new Float32Array(pathStateArray, 148 * constants.pathCount, constants.pathCount),
          ],
          [
            new Float32Array(pathStateArray, 152 * constants.pathCount, constants.pathCount),
            new Float32Array(pathStateArray, 156 * constants.pathCount, constants.pathCount),
          ],
        ],
        sum_inv_ri: [
          new Float32Array(pathStateArray, 160 * constants.pathCount, constants.pathCount),
          new Float32Array(pathStateArray, 164 * constants.pathCount, constants.pathCount),
        ],
        prod_ri: [
          new Float32Array(pathStateArray, 168 * constants.pathCount, constants.pathCount),
          new Float32Array(pathStateArray, 172 * constants.pathCount, constants.pathCount),
        ],
      };
}

function configureCamera() {
    const cameraArray = new ArrayBuffer(64);

    const cameraArrayViews = getCameraArrayViews(cameraArray);

    const direction = sub(scene.camera.lookAt, scene.camera.origin);
    const distance = constants.pixelHeight / (2.0 * Math.tan(scene.camera.fieldOfView / 2.0));
    const basis = orthonormalBasis(direction);
    cameraArrayViews.u.set([basis.u.x, basis.u.y, basis.u.z]);
    cameraArrayViews.v.set([basis.v.x, basis.v.y, basis.v.z]);
    cameraArrayViews.w.set([basis.w.x, basis.w.y, basis.w.z]);
    cameraArrayViews.origin.set([scene.camera.origin.x, scene.camera.origin.y, scene.camera.origin.z]);
    cameraArrayViews.distance.set([distance]);

    return cameraArray;
}

function configureScene() {
    const sphereArray = new ArrayBuffer(28 * scene.spheres.length);

    const sphereArrayViews = getSphereArrayViews(sphereArray);

    for (let i = 0; i < scene.spheres.length; i++) {
        const sphere = scene.spheres[i];
        sphereArrayViews.radius.set([sphere.radius], i);
        sphereArrayViews.center_x.set([sphere.center.x], i);
        sphereArrayViews.center_y.set([sphere.center.y], i);
        sphereArrayViews.center_z.set([sphere.center.z], i);
        sphereArrayViews.color_r.set([sphere.color.r], i);
        sphereArrayViews.color_g.set([sphere.color.g], i);
        sphereArrayViews.color_b.set([sphere.color.b], i);
    }

    return sphereArray;
}

function configureChains() {
    const chainCount = constants.maxPathLength - 1;
    const chainArray = new ArrayBuffer(36 * chainCount);

    const chainArrayViews = getChainArrayViews(chainArray);

    for (let i = 0; i < chainCount; i++) {
        const key = parseKey(keys[i]);
        chainArrayViews.key_hi.set([key.hi], i);
        chainArrayViews.key_lo.set([key.lo], i);
        chainArrayViews.iteration.set([0], i);
        const vertexCount = i + 2;
        const numbersPerStream = vertexCount * constants.numbersPerVertex;
        const numbersPerPath = 2 * numbersPerStream + 1;
        const numbersPerIteration = numbersPerPath * constants.pathCount;
        chainArrayViews.numbers_per_iteration.set([numbersPerIteration], i);
        chainArrayViews.numbers_per_path.set([numbersPerPath], i);
        chainArrayViews.numbers_per_stream.set([numbersPerStream], i);
        chainArrayViews.large_step_index_hi.set([0], i);
        chainArrayViews.large_step_index_lo.set([0], i);
    }

    return chainArray;
}

function configureQueueCounts() {
    const queueCountsArray = new Uint32Array(Array(constants.queueCount).fill(0));
    return queueCountsArray;
}

function configureDispatchIndirectParameters() {
    return new Uint32Array(Array(4 * constants.queueCount).fill(0));
}

function configureInitializeUniforms(params) {
    const uniformsArray = new ArrayBuffer(4);
    const uniformsViews = {
        path_length: new Uint32Array(uniformsArray, 0, 1),
    };
    uniformsViews.path_length.set([params.path_length]);
    return uniformsArray;
}

function configureClearQueueUniforms(params) {
    const uniformsArray = new ArrayBuffer(4);
    const uniformsViews = {
        queue_id: new Uint32Array(uniformsArray, 0, 1),
    };
    uniformsViews.queue_id.set([params.queue_id]);
    return uniformsArray;
}

function configureBuildCdfUniforms(params) {
    const uniformsArray = new ArrayBuffer(12);
    const uniformsViews = {
        min_path_index: new Uint32Array(uniformsArray, 0, 1),
        path_count: new Uint32Array(uniformsArray, 4, 1),
        iteration: new Uint32Array(uniformsArray, 8, 1),
    };
    uniformsViews.min_path_index.set([params.min_path_index]);
    uniformsViews.path_count.set([params.path_count]);
    uniformsViews.iteration.set([params.iteration]);
    return uniformsArray;
}

function prepareDebug(device, buffer, encoder, getView, title) {
    const resultBuffer = device.createBuffer({
        label: 'result buffer',
        size: buffer.size,
        usage: GPUBufferUsage.MAP_READ | GPUBufferUsage.COPY_DST,
    });

    encoder.copyBufferToBuffer(buffer, 0, resultBuffer, 0, resultBuffer.size);

    return { resultBuffer, getView, title };
}

async function debug(d) {
    await d.resultBuffer.mapAsync(GPUMapMode.READ);
    const result = d.resultBuffer.getMappedRange().slice();
    const view = d.getView(result);
    d.resultBuffer.unmap();
    console.log(`${d.title}:`);
    for (let key in view) {
        console.log(`${key}:`);
        console.log(view[key]);
    }
}

function prepareTimestamp(device, querySet, encoder) {
    const resolveBuffer = device.createBuffer({
        size: querySet.count * 8,
        usage: GPUBufferUsage.QUERY_RESOLVE | GPUBufferUsage.COPY_SRC,
    });
    const resultBuffer = device.createBuffer({
        size: resolveBuffer.size,
        usage: GPUBufferUsage.COPY_DST | GPUBufferUsage.MAP_READ,
    });
    encoder.resolveQuerySet(querySet, 0, 2, resolveBuffer, 0);
    if (resultBuffer.mapState === 'unmapped') {
      encoder.copyBufferToBuffer(resolveBuffer, 0, resultBuffer, 0, resultBuffer.size);
    }
    return { resolveBuffer, resultBuffer };
}

async function timestamp(t) {
    if (t.resultBuffer.mapState === 'unmapped') {
        await t.resultBuffer.mapAsync(GPUMapMode.READ).then(() => {
            const times = new BigInt64Array(t.resultBuffer.getMappedRange());
            const gpuTime = Number(times[1] - times[0]) /  1_000_000.0;
            console.log(`elapsed time: ${gpuTime} ms.`);
            t.resultBuffer.unmap();
        });
    }
}

async function main() {
    const memoryLimit = 2_147_483_644;
    const adapter = await navigator.gpu?.requestAdapter({
        powerPreference: 'high-performance',
    });

    const device = await adapter?.requestDevice({
        requiredFeatures: ['timestamp-query'],
        requiredLimits: {
            maxStorageBufferBindingSize: memoryLimit,
            maxBufferSize: memoryLimit,
        },
    });

    if (!device) {
        alert('Your web browser does not support WebGPU');
        return;
    }

    device.addEventListener('uncapturederror', event => console.log(event.error.message));

    const initializeModule = device.createShaderModule({
        label: 'initialize module',
        code: initializeModuleCode,
    });

    const dispatchModule = device.createShaderModule({
        label: 'dispatch module',
        code: dispatchModuleCode,
    });

    const clearQueueModule = device.createShaderModule({
        label: 'clear_queue module',
        code: clearQueueModuleCode,
    });

    const sampleCameraModule = device.createShaderModule({
        label: 'sample_camera module',
        code: sampleCameraModuleCode,
    });

    const sampleLightModule = device.createShaderModule({
        label: 'sample_light module',
        code: sampleLightModuleCode,
    });

    const intersectModule = device.createShaderModule({
        label: 'intersect module',
        code: intersectModuleCode,
    });

    const buildCdfModule = device.createShaderModule({
        label: 'build_cdf module',
        code: buildCdfModuleCode,
    });

    const primaryBindGroupLayout = device.createBindGroupLayout({
        entries: [
            {
                binding: constants.cameraBinding,
                visibility: GPUShaderStage.COMPUTE,
                buffer: {
                    type: 'read-only-storage',
                },
            },
            {
                binding: constants.sphereBinding,
                visibility: GPUShaderStage.COMPUTE,
                buffer: {
                    type: 'read-only-storage',
                },
            },
            {
                binding: constants.chainBinding,
                visibility: GPUShaderStage.COMPUTE,
                buffer: {
                    type: 'storage',
                },
            },
            {
                binding: constants.pathStateBinding,
                visibility: GPUShaderStage.COMPUTE,
                buffer: {
                    type: 'storage',
                },
            },
            {
                binding: constants.imageBinding,
                visibility: GPUShaderStage.COMPUTE,
                buffer: {
                    type: 'storage',
                },
            },
            {
                binding: constants.queuesBinding,
                visibility: GPUShaderStage.COMPUTE,
                buffer: {
                    type: 'storage',
                },
            },
            {
                binding: constants.queueCountsBinding,
                visibility: GPUShaderStage.COMPUTE,
                buffer: {
                    type: 'storage',
                },
            },
        ],
    });

    const auxiliaryBindGroupLayout = device.createBindGroupLayout({
        entries: [
            {
                binding: constants.dispatchIndirectParametersBinding,
                visibility: GPUShaderStage.COMPUTE,
                buffer: {
                    type: 'storage',
                },
            },
        ],
    });

    const uniformsBindGroupLayout = device.createBindGroupLayout({
        entries: [
            {
                binding: constants.uniformsBinding,
                visibility: GPUShaderStage.COMPUTE,
                buffer: {
                    type: 'uniform',
                },
            },
        ],
    });

    const primaryPipelineLayout = device.createPipelineLayout({
        bindGroupLayouts: [
            primaryBindGroupLayout,
        ],
    });

    const auxiliaryPipelineLayout = device.createPipelineLayout({
        bindGroupLayouts: [
            primaryBindGroupLayout,
            auxiliaryBindGroupLayout,
        ],
    });

    const parameterizedPipelineLayout = device.createPipelineLayout({
        bindGroupLayouts: [
            primaryBindGroupLayout,
            auxiliaryBindGroupLayout,
            uniformsBindGroupLayout,
        ],
    });

    const cameraArray = configureCamera();

    const cameraBuffer = device.createBuffer({
        label: 'camera buffer',
        size: cameraArray.byteLength,
        usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST,
    });

    device.queue.writeBuffer(cameraBuffer, 0, cameraArray);

    const sphereArray = configureScene();

    const sphereBuffer = device.createBuffer({
        label: 'sphere buffer',
        size: sphereArray.byteLength,
        usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST,
    });

    device.queue.writeBuffer(sphereBuffer, 0, sphereArray);

    const chainArray = configureChains();

    const chainBuffer = device.createBuffer({
        label: 'chain buffer',
        size: chainArray.byteLength,
        usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST,
    });

    device.queue.writeBuffer(chainBuffer, 0, chainArray);

    const pathStateBuffer = device.createBuffer({
        label: 'path state buffer',
        size: 176 * constants.pathCount,
        usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST | GPUBufferUsage.COPY_SRC,
    });

    const imageBuffer = device.createBuffer({
        label: 'image buffer',
        size: 12 * constants.pixelWidth * constants.pixelHeight,
        usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST,
    });

    const queuesBuffer = device.createBuffer({
        label: 'queues buffer',
        size: 4 * constants.queueCount * constants.pathCount,
        usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST,
    });

    const queueCountsArray = configureQueueCounts();

    const queueCountsBuffer = device.createBuffer({
        label: 'queue counts buffer',
        size: queueCountsArray.byteLength,
        usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST,
    });

    device.queue.writeBuffer(queueCountsBuffer, 0, queueCountsArray);

    const dispatchIndirectParametersArray = configureDispatchIndirectParameters();

    const dispatchIndirectParametersBuffer = device.createBuffer({
        label: 'dispatch indirect parameters buffer',
        size: dispatchIndirectParametersArray.byteLength,
        usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST | GPUBufferUsage.INDIRECT,
    });

    device.queue.writeBuffer(dispatchIndirectParametersBuffer, 0, dispatchIndirectParametersArray);
    
    const primaryBindGroup = device.createBindGroup({
        label: 'primary bind group',
        layout: primaryBindGroupLayout,
        entries: [
            {
                binding: constants.cameraBinding,
                resource: {
                    buffer: cameraBuffer,
                },
            },
            {
                binding: constants.sphereBinding,
                resource: {
                    buffer: sphereBuffer,
                },
            },
            {
                binding: constants.chainBinding,
                resource: {
                    buffer: chainBuffer,
                },
            },
            {
                binding: constants.pathStateBinding,
                resource: {
                    buffer: pathStateBuffer,
                },
            },
            {
                binding: constants.imageBinding,
                resource: {
                    buffer: imageBuffer,
                },
            },
            {
                binding: constants.queuesBinding,
                resource: {
                    buffer: queuesBuffer,
                },
            },
            {
                binding: constants.queueCountsBinding,
                resource: {
                    buffer: queueCountsBuffer,
                },
            },
        ],
    });

    const auxiliaryBindGroup = device.createBindGroup({
        label: 'auxiliary bind group',
        layout: auxiliaryBindGroupLayout,
        entries: [
            {
                binding: constants.dispatchIndirectParametersBinding,
                resource: {
                    buffer: dispatchIndirectParametersBuffer,
                }
            }
        ],
    });

    let uniformsArray = configureInitializeUniforms({
        path_length: 2,
    });

    let uniformsBuffer = device.createBuffer({
        label: 'uniforms buffer',
        size: uniformsArray.byteLength,
        usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST,
    });

    device.queue.writeBuffer(uniformsBuffer, 0, uniformsArray);

    let uniformsBindGroup = device.createBindGroup({
        label: 'uniforms bind group',
        layout: uniformsBindGroupLayout,
        entries: [
            {
                binding: constants.uniformsBinding,
                resource: {
                    buffer: uniformsBuffer,
                },
            },
        ],
    });

    const querySet = device.createQuerySet({
        type: 'timestamp',
        count: 2,
    });

    const initializePipeline = device.createComputePipeline({
        label: 'initialize compute pipeline',
        layout: parameterizedPipelineLayout,
        compute: {
            module: initializeModule,
        }
    });

    let encoder = device.createCommandEncoder({
        label: 'command encoder',
    });

    let pass = encoder.beginComputePass({
        label: 'initialize compute pass',
        timestampWrites: {
            querySet,
            beginningOfPassWriteIndex: 0,
            endOfPassWriteIndex: 1,
        },
    });
    pass.setPipeline(initializePipeline);
    pass.setBindGroup(0, primaryBindGroup);
    pass.setBindGroup(1, auxiliaryBindGroup);
    pass.setBindGroup(2, uniformsBindGroup);
    pass.dispatchWorkgroups(Math.ceil(constants.pathCount / constants.workgroupSize));
    pass.end();
    
    let commandBuffer = encoder.finish();
    device.queue.submit([commandBuffer]);

    let dispatchPipeline = device.createComputePipeline({
        label: 'dispatch pipeline',
        layout: auxiliaryPipelineLayout,
        compute: {
            module: dispatchModule,
        },
    });

    encoder = device.createCommandEncoder({
        label: 'command encoder',
    });

    pass = encoder.beginComputePass({
        label: 'dispatch compute pass',
        timestampWrites: {
            querySet,
            beginningOfPassWriteIndex: 0,
            endOfPassWriteIndex: 1,
        },
    });
    pass.setPipeline(dispatchPipeline);
    pass.setBindGroup(0, primaryBindGroup);
    pass.setBindGroup(1, auxiliaryBindGroup);
    pass.dispatchWorkgroups(1);
    pass.end();

    commandBuffer = encoder.finish();
    device.queue.submit([commandBuffer]);

    const sampleCameraPipeline = device.createComputePipeline({
        label: 'sample_camera compute pipeline',
        layout: primaryPipelineLayout,
        compute: {
            module: sampleCameraModule,
        },
    });

    encoder = device.createCommandEncoder({
        label: 'command encoder',
    });

    pass = encoder.beginComputePass({
        label: 'sample_camera compute pass',
        timestampWrites: {
            querySet,
            beginningOfPassWriteIndex: 0,
            endOfPassWriteIndex: 1,
        },
    });
    pass.setPipeline(sampleCameraPipeline);
    pass.setBindGroup(0, primaryBindGroup);
    pass.dispatchWorkgroupsIndirect(dispatchIndirectParametersBuffer, 16 * constants.sampleCameraQueueId);
    pass.end();

    commandBuffer = encoder.finish();
    device.queue.submit([commandBuffer]);

    uniformsArray = configureClearQueueUniforms({
        queue_id: constants.sampleCameraQueueId,
    });

    uniformsBuffer = device.createBuffer({
        label: 'uniforms buffer',
        size: uniformsArray.byteLength,
        usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST,
    });

    device.queue.writeBuffer(uniformsBuffer, 0, uniformsArray);

    uniformsBindGroup = device.createBindGroup({
        label: 'uniforms bind group',
        layout: uniformsBindGroupLayout,
        entries: [
            {
                binding: constants.uniformsBinding,
                resource: {
                    buffer: uniformsBuffer,
                },
            },
        ],
    });

    const clearQueuePipeline = device.createComputePipeline({
        label: 'clear_queue pipeline',
        layout: parameterizedPipelineLayout,
        compute: {
            module: clearQueueModule,
        },
    });

    encoder = device.createCommandEncoder({
        label: 'command encoder',
    });

    pass = encoder.beginComputePass({
        label: 'clear_queue compute pass',
        timestampWrites: {
            querySet,
            beginningOfPassWriteIndex: 0,
            endOfPassWriteIndex: 1,
        },
    });
    pass.setPipeline(clearQueuePipeline);
    pass.setBindGroup(0, primaryBindGroup);
    pass.setBindGroup(1, auxiliaryBindGroup);
    pass.setBindGroup(2, uniformsBindGroup);
    pass.dispatchWorkgroups(1);
    pass.end();

    commandBuffer = encoder.finish();
    device.queue.submit([commandBuffer]);

    encoder = device.createCommandEncoder({
        label: 'command encoder',
    });

    pass = encoder.beginComputePass({
        label: 'dispatch compute pass',
        timestampWrites: {
            querySet,
            beginningOfPassWriteIndex: 0,
            endOfPassWriteIndex: 1,
        },
    });
    pass.setPipeline(dispatchPipeline);
    pass.setBindGroup(0, primaryBindGroup);
    pass.setBindGroup(1, auxiliaryBindGroup);
    pass.dispatchWorkgroups(1);
    pass.end();

    commandBuffer = encoder.finish();
    device.queue.submit([commandBuffer]);

    const sampleLightPipeline = device.createComputePipeline({
        label: 'sample_light compute pipeline',
        layout: primaryPipelineLayout,
        compute: {
            module: sampleLightModule,
        },
    });

    encoder = device.createCommandEncoder({
        label: 'command encoder',
    });

    pass = encoder.beginComputePass({
        label: 'sample_light compute pass',
        timestampWrites: {
            querySet,
            beginningOfPassWriteIndex: 0,
            endOfPassWriteIndex: 1,
        },
    });
    pass.setPipeline(sampleLightPipeline);
    pass.setBindGroup(0, primaryBindGroup);
    pass.dispatchWorkgroupsIndirect(dispatchIndirectParametersBuffer, 16 * constants.sampleLightQueueId);
    pass.end();

    commandBuffer = encoder.finish();
    device.queue.submit([commandBuffer]);

    uniformsArray = configureClearQueueUniforms({
        queue_id: constants.sampleLightQueueId,
    });

    uniformsBuffer = device.createBuffer({
        label: 'uniforms buffer',
        size: uniformsArray.byteLength,
        usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST,
    });

    device.queue.writeBuffer(uniformsBuffer, 0, uniformsArray);

    uniformsBindGroup = device.createBindGroup({
        label: 'uniforms bind group',
        layout: uniformsBindGroupLayout,
        entries: [
            {
                binding: constants.uniformsBinding,
                resource: {
                    buffer: uniformsBuffer,
                },
            },
        ],
    });

    encoder = device.createCommandEncoder({
        label: 'command encoder',
    });

    pass = encoder.beginComputePass({
        label: 'clear_queue compute pass',
        timestampWrites: {
            querySet,
            beginningOfPassWriteIndex: 0,
            endOfPassWriteIndex: 1,
        },
    });
    pass.setPipeline(clearQueuePipeline);
    pass.setBindGroup(0, primaryBindGroup);
    pass.setBindGroup(1, auxiliaryBindGroup);
    pass.setBindGroup(2, uniformsBindGroup);
    pass.dispatchWorkgroups(1);
    pass.end();

    commandBuffer = encoder.finish();
    device.queue.submit([commandBuffer]);

    const intersectPipeline = device.createComputePipeline({
        label: 'intersect compute pipeline',
        layout: primaryPipelineLayout,
        compute: {
            module: intersectModule,
        },
    });

    encoder = device.createCommandEncoder({
        label: 'command encoder',
    });

    pass = encoder.beginComputePass({
        label: 'intersect compute pass',
        timestampWrites: {
            querySet,
            beginningOfPassWriteIndex: 0,
            endOfPassWriteIndex: 1,
        },
    });
    pass.setPipeline(intersectPipeline);
    pass.setBindGroup(0, primaryBindGroup);
    pass.dispatchWorkgroupsIndirect(dispatchIndirectParametersBuffer, 16 * constants.intersectQueueId);
    pass.end();

    commandBuffer = encoder.finish();
    device.queue.submit([commandBuffer]);

    const buildCdfPipeline = device.createComputePipeline({
        label: 'build_cdf compute pipeline',
        layout: parameterizedPipelineLayout,
        compute: {
            module: buildCdfModule,
        },
    });

    encoder = device.createCommandEncoder({
        label: 'command encoder',
    });

    pass = encoder.beginComputePass({
        label: 'build_cdf compute pass',
        timestampWrites: {
            querySet,
            beginningOfPassWriteIndex: 0,
            endOfPassWriteIndex: 1,
        },
    });
    pass.setPipeline(buildCdfPipeline);
    pass.setBindGroup(0, primaryBindGroup);
    pass.setBindGroup(1, auxiliaryBindGroup);

    for (let i = 0; i < Math.ceil(Math.log2(constants.pathCount)); i++) {
        uniformsArray = configureBuildCdfUniforms({
            min_path_index: 0,
            path_count: constants.pathCount,
            iteration: i,
        });
    
        uniformsBuffer = device.createBuffer({
            label: 'uniforms buffer',
            size: uniformsArray.byteLength,
            usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST,
        });
    
        device.queue.writeBuffer(uniformsBuffer, 0, uniformsArray);
    
        uniformsBindGroup = device.createBindGroup({
            label: 'uniforms bind group',
            layout: uniformsBindGroupLayout,
            entries: [
                {
                    binding: constants.uniformsBinding,
                    resource: {
                        buffer: uniformsBuffer,
                    },
                },
            ],
        });

        pass.setBindGroup(2, uniformsBindGroup);
        pass.dispatchWorkgroups(Math.ceil(constants.pathCount / constants.workgroupSize));
    }

    pass.end();

    //const d = prepareDebug(device, pathStateBuffer, encoder, getPathStateArrayViews, 'path state');
    const t = prepareTimestamp(device, querySet, encoder);

    commandBuffer = encoder.finish();
    device.queue.submit([commandBuffer]);

    //await debug(d);
    await timestamp(t);
}

main();