# Kai Monkey's Traits

A comprehensive mod (game modification) for [Stonehearth](https://store.steampowered.com/app/253250/Stonehearth/) that adds **nine unique character traits** to make each hearthling distinctive. Each character (hearthling) has between 1 and two traits, randomly selected from the pool.
This increases the pool of traits that make characters feel and play unique by 50%, from 21 to 30! 
Developed from **2018-2019**, this project involved working with the game's Lua scripting API, JSON data structures, and component systems to extend core gameplay mechanics.

*Game modding involves programming custom features and content that extend existing games beyond their original scope, requiring integration with existing codebases and APIs.*

## 🎮 Features

**Nine Brand New Character Traits:**
- **Barbarian** - Unique visual assets, modified combat stats, equipment restrictions via scripted logic
- **Martial Trained** - Dynamic weapon compatibility system that overrides default job restrictions  
- **Divine Soul** - Custom class mechanics and special abilities implementation
- **Scarred** - Multi-attribute stat modifications with persistent visual changes
- **Pacifist** - Modified AI behavior trees for non-combat gameplay
- **Wizened** - Elder character mechanics with wisdom-based stat bonuses
- **Goblin** - Complete visual transformation system with model/texture swapping
- **Plus 2 additional traits** with unique gameplay mechanics

**Technical Implementation:**
- ✨ **Custom Asset Integration** - 3D models, textures, and animations
- ⚔️ **Gameplay Logic** - Lua scripting for trait behaviors and interactions
- 🎯 **Data-Driven Design** - JSON configuration files for easy modification
- 🔧 **Bug Fixes** - Resolved existing game issues (enabled broken "Magnificent Beard" trait)
- 🎲 **Extensible Framework** - Modular system allowing additional traits

## 📦 Installation

### Steam Workshop (Recommended)
1. Subscribe to [Kai Monkey's Traits - Version 3.51](https://steamcommunity.com/sharedfiles/filedetails/?id=1410871392) on Steam Workshop
2. Launch Stonehearth - the mod will auto-download and install

### Manual Installation
1. Download the latest release from this repository
2. Extract to your Stonehearth mods directory (`steamapps/common/stonehearth/mods/`)
3. Enable the mod in-game through the mod menu

## 🛠️ Console Commands

Developer commands for testing and debugging:

```
add_trait [hearthling_id] kmnky_traits:[trait_name]
remove_trait [hearthling_id] kmnky_traits:[trait_name]
```

**Note:** The mod namespace is `kmnky_traits`

## ⚠️ Known Issues & Compatibility

**Compatibility Challenges:**
- **ACE Mod Integration**: Conflicts with some advanced content expansion features
- **Martial Trained Logic**: Occasional priority conflicts in weapon/tool selection algorithms
- **Divine Soul State**: Class change mechanics can conflict with save/reload systems
- **Job Tree Dependencies**: Some traits modify core progression systems

**Mod Conflicts:**
- Locks Of Many Hair mod (asset pipeline conflicts)
- Northern Alliance mod (some mechanical overlaps)

**Community Solutions:**
- [Mod Repairer](https://steamcommunity.com/workshop/filedetails/?id=1846248864) available for compatibility fixes

## 📊 Project Stats

- **Development Period**: 2018-2019 during active game community
- **10,000+ Active Users** via Steam Workshop  
- **Version 3.51** - Multiple iteration cycles based on community feedback (Released July 2018, updated through 2019)
- **200+ Community Comments** with feature requests and bug reports
- **GitHub Repository**: Development version (Steam Workshop recommended for updates)

## 🐛 Bug Reports & Development

**Community Feedback Channels:**
- GitHub Issues (this repository)
- [Stonehearth Discourse](https://discourse.stonehearth.net/t/mod-kaimonkeys-traits-version-3-now-with-pacifists-barbarians-and-more/36714)
- Steam Workshop comments

## 📋 Development Notes

This mod was developed during **2018-2019** within an active gaming community and demonstrates working within an existing game engine's constraints while extending functionality through:
- **API Integration** with Stonehearth's component-entity system
- **Asset Pipeline Management** for custom visual content  
- **Scripted Behavior Systems** using Lua for game logic
- **Community-Driven Development** with iterative releases based on user feedback

The project required reverse-engineering game systems, debugging complex mod interactions, and maintaining compatibility across game updates during the active development period.

## 🙏 Credits

**Developer:** kaisalmon (Kai Monkey)  
**Community Contributors:**
- **Thahat** - Localization system implementation and translatable text support (2018)
- **BrunoSupremo** - Critical job tree bug fixes for mod compatibility (2021)

**Community:** Stonehearth modding community for testing and feedback

---

*A character customization system that transforms generic game units into unique individuals through scripted traits, custom assets, and gameplay modifications.*
