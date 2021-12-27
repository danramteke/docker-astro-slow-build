# Minimal bug repro

This repo highlights very slow builds when building in Docker. On both Intel chips and Apple chips. When building on host OS, it's totally fine.

Link to issue filed with Astro: https://github.com/withastro/astro/issues/2279

## Repro Steps

`docker build .`

## Output
```
$ docker build .
[+] Building 192.0s (13/14)                                                                       
 => [internal] load build definition from Dockerfile                                         0.0s
 => => transferring dockerfile: 37B                                                          0.0s
 => [internal] load .dockerignore                                                            0.0s
 => => transferring context: 2B                                                              0.0s
 => [internal] load metadata for docker.io/library/nginx:latest                              0.3s
 => [internal] load metadata for docker.io/library/node:17                                   0.3s
 => [internal] load build context                                                            0.0s
 => => transferring context: 4.83kB                                                          0.0s
 => [stage-1 1/2] FROM docker.io/library/nginx@sha256:366e9f1ddebdb844044c2fafd13b75271a9f6  0.0s
 => CACHED [builder 1/7] FROM docker.io/library/node:17@sha256:36aca218a5eb57cb23bc790a0305  0.0s
 => [builder 2/7] COPY package.json ./                                                       0.0s
 => [builder 3/7] COPY yarn.lock ./                                                          0.0s
 => [builder 4/7] RUN yarn install                                                          25.4s
 => [builder 5/7] COPY src src                                                               0.0s
 => [builder 6/7] COPY public public                                                         0.1s
 => ERROR [builder 7/7] RUN yarn build                                                     166.0s 
------                                                                                            
 > [builder 7/7] RUN yarn build:
#13 0.373 yarn run v1.22.17
#13 0.386 warning package.json: No license field
#13 0.400 $ astro build
#13 1.573 04:18 AM [config] Set "buildOptions.site" to generate correct canonical URLs and sitemap
#13 165.5 
#13 165.5 <--- Last few GCs --->
#13 165.5 
#13 165.5 [29:0x57fb160]   162442 ms: Scavenge 2006.2 (2077.1) -> 1998.6 (2077.1) MB, 7.9 / 0.0 ms  (average mu = 0.251, current mu = 0.071) allocation failure 
#13 165.5 [29:0x57fb160]   162531 ms: Scavenge 2010.2 (2077.1) -> 2002.3 (2081.1) MB, 7.4 / 0.0 ms  (average mu = 0.251, current mu = 0.071) allocation failure 
#13 165.5 [29:0x57fb160]   163720 ms: Mark-sweep 2014.2 (2081.1) -> 1989.6 (2084.9) MB, 1115.0 / 2.2 ms  (average mu = 0.296, current mu = 0.338) allocation failure scavenge might not succeed
#13 165.5 
#13 165.5 
#13 165.5 <--- JS stacktrace --->
#13 165.5 
#13 165.5 FATAL ERROR: Ineffective mark-compacts near heap limit Allocation failed - JavaScript heap out of memory
#13 165.5  1: 0xb2c2b0 node::Abort() [/usr/local/bin/node]
#13 165.5  2: 0xa4025c node::FatalError(char const*, char const*) [/usr/local/bin/node]
#13 165.5  3: 0xd1d11e v8::Utils::ReportOOMFailure(v8::internal::Isolate*, char const*, bool) [/usr/local/bin/node]
#13 165.5  4: 0xd1d497 v8::internal::V8::FatalProcessOutOfMemory(v8::internal::Isolate*, char const*, bool) [/usr/local/bin/node]
#13 165.5  5: 0xed68f5  [/usr/local/bin/node]
#13 165.5  6: 0xed73d6  [/usr/local/bin/node]
#13 165.5  7: 0xee704c  [/usr/local/bin/node]
#13 165.5  8: 0xee7ac0 v8::internal::Heap::CollectGarbage(v8::internal::AllocationSpace, v8::internal::GarbageCollectionReason, v8::GCCallbackFlags) [/usr/local/bin/node]
#13 165.5  9: 0xeeaa6e v8::internal::Heap::AllocateRawWithRetryOrFailSlowPath(int, v8::internal::AllocationType, v8::internal::AllocationOrigin, v8::internal::AllocationAlignment) [/usr/local/bin/node]
#13 165.5 10: 0xeac48a v8::internal::Factory::NewFillerObject(int, bool, v8::internal::AllocationType, v8::internal::AllocationOrigin) [/usr/local/bin/node]
#13 165.5 11: 0x122c8e8 v8::internal::Runtime_AllocateInYoungGeneration(int, unsigned long*, v8::internal::Isolate*) [/usr/local/bin/node]
#13 165.5 12: 0x162fb79  [/usr/local/bin/node]
#13 165.9 Aborted
#13 165.9 error Command failed with exit code 134.
#13 165.9 info Visit https://yarnpkg.com/en/docs/cli/run for documentation about this command.
------
executor failed running [/bin/sh -c yarn build]: exit code: 134
```