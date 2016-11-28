# Website of Computation and Cryptography with Qubits-2017 workshop (affiliated with CSR 2017)

## To build locally

* install GHC and cabal using your package manager (e.g. `apt-get install ghc cabal-install`)
* run `cabal build` in root dir
* run `site watch` to start local server and recompile on changes

## To deploy

* recompile `site.hs` if `site.hs` was changed
* run `site rebuild` if `site.hs` was changed, otherwise run `site build`
* copy `_site` dir to server

