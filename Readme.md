# Where
## 🗓 Todos
### Edit photos
- Select existing points (rename, delete).
- Show all the points in 'PhotoView', navigate to 'PointView'
- Image pinch to zoom (Optional)

- Take photos
- Edit folders
- Duplicate folder/photo names
- Add popup when deleting a folder with children
- Check whether the data type of 'children' & 'photos' are NSSet
- **Search function**
- BrowseView (Optional)
- Recently Deleted (Optional)
- Add tags (Optional)
- Password protection

## ⚠️ Issues
- 'PointView': UI will not be updated while deleting points. (self.point.remove(at: currPointNum) will report index out of range error)

- ‘FolderView': Deleting folders will report issues
- 'FolderView': [UILog] Called -[UIContextMenuInteraction updateVisibleMenuWithBlock:] while no context menu is visible. This won't do anything.

- 'UserView': Save AppleID Login Data and retrieve it from UserDefaults.
- 'UserView': Update View after log in
- 'UserView': Handle log out button

## 📦 Packages
- 'Introspect': Hide tab bar
