# vcpkg-registry

A custom vcpkg registry for C/C++ ports.

## Ports

- `libxmp-lite`
- `sdl3`

## Usage

Add this repository as a registry in your `vcpkg-configuration.json`:

```json
{
  "registries": [
    {
      "kind": "git",
      "baseline": "<commit-sha>",
      "repository": "https://github.com/XunJang/vcpkg-registry",
      "packages": [
        "libxmp-lite",
        "sdl3"
      ]
    }
  ]
}
```

Replace `<commit-sha>` with the commit you want to pin.

## Notes

This registry follows the vcpkg registry layout:

- `ports/` contains port definitions.
- `versions/` contains version metadata and the baseline.
