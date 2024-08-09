---
sidebar_position: 2
---

# Installation

## Method #1 - RepoToRoblox

Using the RepoToRoblox plugin is the easiest way to install in Studio.

1. Make sure you have set your GitHub authentication token in the plugin settings.
2. In the RepoToRoblox widget, enter `bura-games` as the owner and `greentea-utilities` as the repository.
3. Click the Clone Repository button.

## Method 2 - Manual

1. Visit the [latest release](https://github.com/Bura-Games/greentea-utilities/releases)
2. Under *Assets*, click `GreenTeaUtilities.rbxm`
3. - Using [Rojo](https://rojo.space/)? Put the file somewhere where Rojo can sync it.
   - Using Roblox Studio? Drag the file onto the viewport. It should insert under Workspace.

## Method 3 - Wally

1. Setup [Wally](https://wally.run/) by using `wally init`.
2. Add `howmanysmall/greentea-utilities` as a dependency.

```toml
[dependencies]
GreenTeaUtilities = "howmanysmall/greentea-utilities@^1.0.0"
```
