# Minimal bug repro

This repo highlights very slow builds when building in Docker. On both Intel chips and Apple chips. When building on host OS, it's totally fine.

## Issue 

Link to issues filed with Astro: 
- https://github.com/withastro/astro/issues/2279
- https://github.com/withastro/astro/issues/2596

## Github Action

Link to a run on GitHub actions with the same failure. https://github.com/danramteke/docker-astro-slow-build/runs/4643816143?check_suite_focus=true 

## Repro 

### Steps

`docker build .`

### Output
```
$ docker build .
[+] Building 165.5s (13/14)                                                                                                                                     
 => [internal] load build definition from Dockerfile                                                                                                       0.0s
 => => transferring dockerfile: 37B                                                                                                                        0.0s
 => [internal] load .dockerignore                                                                                                                          0.0s
 => => transferring context: 34B                                                                                                                           0.0s
 => [internal] load metadata for docker.io/library/nginx:latest                                                                                            0.2s
 => [internal] load metadata for docker.io/library/node:17                                                                                                 0.2s
 => CACHED [builder 1/7] FROM docker.io/library/node:17@sha256:36aca218a5eb57cb23bc790a030591382c7664c15a384e2ddc2075761ac7e701                            0.0s
 => CACHED [stage-1 1/2] FROM docker.io/library/nginx@sha256:0d17b565c37bcbd895e9d92315a05c1c3c9a29f762b011a10c54a66cd53c9b31                              0.0s
 => [internal] load build context                                                                                                                          0.0s
 => => transferring context: 173.77kB                                                                                                                      0.0s
 => [builder 2/7] COPY package.json ./                                                                                                                     0.1s
 => [builder 3/7] COPY yarn.lock ./                                                                                                                        0.0s
 => [builder 4/7] RUN yarn install                                                                                                                        24.9s
 => [builder 5/7] COPY src src                                                                                                                             0.0s 
 => [builder 6/7] COPY public public                                                                                                                       0.0s 
 => ERROR [builder 7/7] RUN yarn build                                                                                                                   140.1s 
------                                                                                                                                                          
 > [builder 7/7] RUN yarn build:                                                                                                                                
#13 0.433 yarn run v1.22.17                                                                                                                                     
#13 0.461 warning package.json: No license field                                                                                                                
#13 0.487 $ astro build --verbose                                                                                                                               
#13 1.642 05:41 PM [config] Set "buildOptions.site" to generate correct canonical URLs and sitemap                                                              
#13 3.179 05:42 PM [build] Vite started   1.6s
#13 11.60 05:42 PM [build] ├── ✔ src/pages/index.astro → /index.html
#13 139.5 
#13 139.5 <--- Last few GCs --->
#13 139.5 
#13 139.5 [31:0x57891d0]   139012 ms: Scavenge 2024.4 (2083.4) -> 2019.7 (2083.9) MB, 7.2 / 0.0 ms  (average mu = 0.491, current mu = 0.331) allocation failure 
#13 139.5 [31:0x57891d0]   139066 ms: Scavenge 2025.2 (2083.9) -> 2022.2 (2086.1) MB, 6.6 / 0.0 ms  (average mu = 0.491, current mu = 0.331) allocation failure 
#13 139.5 [31:0x57891d0]   139116 ms: Scavenge 2027.6 (2086.1) -> 2024.6 (2104.6) MB, 12.1 / 0.0 ms  (average mu = 0.491, current mu = 0.331) allocation failure 
#13 139.5 
#13 139.5 
#13 139.5 <--- JS stacktrace --->
#13 139.5 
#13 139.5 FATAL ERROR: Reached heap limit Allocation failed - JavaScript heap out of memory
#13 139.6  1: 0xb2c2b0 node::Abort() [/usr/local/bin/node]
#13 139.6  2: 0xa4025c node::FatalError(char const*, char const*) [/usr/local/bin/node]
#13 139.6  3: 0xd1d11e v8::Utils::ReportOOMFailure(v8::internal::Isolate*, char const*, bool) [/usr/local/bin/node]
#13 139.6  4: 0xd1d497 v8::internal::V8::FatalProcessOutOfMemory(v8::internal::Isolate*, char const*, bool) [/usr/local/bin/node]
#13 139.6  5: 0xed68f5  [/usr/local/bin/node]
#13 139.6  6: 0xee7d3d v8::internal::Heap::CollectGarbage(v8::internal::AllocationSpace, v8::internal::GarbageCollectionReason, v8::GCCallbackFlags) [/usr/local/bin/node]
#13 139.6  7: 0xeeaa6e v8::internal::Heap::AllocateRawWithRetryOrFailSlowPath(int, v8::internal::AllocationType, v8::internal::AllocationOrigin, v8::internal::AllocationAlignment) [/usr/local/bin/node]
#13 139.6  8: 0xeac48a v8::internal::Factory::NewFillerObject(int, bool, v8::internal::AllocationType, v8::internal::AllocationOrigin) [/usr/local/bin/node]
#13 139.6  9: 0x122c8e8 v8::internal::Runtime_AllocateInYoungGeneration(int, unsigned long*, v8::internal::Isolate*) [/usr/local/bin/node]
#13 139.6 10: 0x162fb79  [/usr/local/bin/node]
#13 140.0 Aborted
#13 140.0 error Command failed with exit code 134.
#13 140.0 info Visit https://yarnpkg.com/en/docs/cli/run for documentation about this command.
------
executor failed running [/bin/sh -c yarn build]: exit code: 134
```

## Output outside of Docker

```
$ yarn build
yarn run v1.22.17
warning package.json: No license field
$ astro build --verbose
12:41 PM [config] Set "buildOptions.site" to generate correct canonical URLs and sitemap
12:41 PM [build] Vite started   328ms
12:41 PM [build] ├── ✔ src/pages/index.astro → /index.html
12:41 PM [build] ├── ✔ src/pages/post.md → /post/index.html
12:41 PM [build] All pages loaded   497ms
12:41 PM [build] Vite build finished   66ms
12:41 PM [build] Additional assets copied   0ms
12:41 PM [build] Sitemap built   0ms
12:41 PM 
12:41 PM [build] 2 pages built in 0.89s (446ms/page)
12:41 PM [build] 🚀 Done
✨  Done in 1.81s.
```
