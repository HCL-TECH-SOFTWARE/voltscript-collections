# VoltScript Collections

Collections and Map classes for LotusScript and VoltScript.

Aims:

- Provide simple, flexible, extensible collections and maps.
- Allow a collection to be instantiated from values _immediately_. This is not possible if you do `Dim foo() as String`.
- Provide unsorted, sorted, unique, sorted unique collections and maps.
- Make the sorting method a property of the collection, to minimise the number of collections required.
- Hide the complexity of optimising sorting from the end user.
- Reuse collections for the keys in a Map.

## Using dependency management

Dependency management is available in the documentation for each project, but also aggregated here:

### Authentication

You'll need a [Personal Access Token](https://help.hcltechsw.com/docs/voltscript/early-access/howto/writing/archipelago.md#github-personal-access-token) to use GitHub REST APIs. You'll then need to add this to the JSON object in your [atlas-settings.json](https://help.hcltechsw.com/docs/voltscript/early-access/howto/writing/archipelago.md#atlas-settingsjson), in the .vss directory of your user home directory:

```json
    "hcl-github": {
        "type": "github",
        "token": "YOUR_TOKEN"
    }
```

### Repository

You'll need to add to your **repositories** object in the atlas.json of your project:

```json
        {
            "id": "hcl-github",
            "type": "github",
            "url": "https://api.github.com/repos/HCL-TECH-SOFTWARE"
        }
```

### Dependency

You'll need the relevant dependency to add to your **dependencies** or **testDependencies** object in the atlas.json of your project:

```json
        {
            "library": "voltscript-collections",
            "version": "1.0.2",
            "module": "VoltScriptCollections.vss",
            "repository": "hcl-github"
        }
```

## Contributing

See [CONTRIBUTING.md](contributing.md).

## Code of Conduct

See [CODE_OF_CONDUCT.md](code_of_conduct.md).

## Issues and discussions

Let's chat on [OpenNTF Discord](https://openntf.org/discord).

For long-running discussions, use Discussions area in GitHub. For bugs and feature requests **specific to VoltScript Testing Framework** use, Issues area.