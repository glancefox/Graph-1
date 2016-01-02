//
// Copyright (C) 2015 CosmicMind, Inc. <http://cosmicmind.io>.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program located at the root of the software package
// in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
//

import CoreData

public extension Graph {
	/**
		:name:	watchForEntity(types: groups: properties)
	*/
	public func watchForEntity(types types: Array<String>? = nil, groups: Array<String>? = nil, properties: Array<String>? = nil) {
		if let v: Array<String> = types {
			for x in v {
				watch(Entity: x)
			}
		}
		
		if let v: Array<String> = groups {
			for x in v {
				watch(EntityGroup: x)
			}
		}
		
		if let v: Array<String> = properties {
			for x in v {
				watch(EntityProperty: x)
			}
		}
	}
	
	/**
		:name:	watchForAction(types: groups: properties)
	*/
	public func watchForAction(types types: Array<String>? = nil, groups: Array<String>? = nil, properties: Array<String>? = nil) {
		if let v: Array<String> = types {
			for x in v {
				watch(Action: x)
			}
		}
		
		if let v: Array<String> = groups {
			for x in v {
				watch(ActionGroup: x)
			}
		}
		
		if let v: Array<String> = properties {
			for x in v {
				watch(ActionProperty: x)
			}
		}
	}
	
	/**
		:name:	watchForBond(types: groups: properties)
	*/
	public func watchForBond(types types: Array<String>? = nil, groups: Array<String>? = nil, properties: Array<String>? = nil) {
		if let v: Array<String> = types {
			for x in v {
				watch(Bond: x)
			}
		}
		
		if let v: Array<String> = groups {
			for x in v {
				watch(BondGroup: x)
			}
		}
		
		if let v: Array<String> = properties {
			for x in v {
				watch(BondProperty: x)
			}
		}
	}
	
	//
	//	:name:	watch(Entity)
	//
	internal func watch(Entity type: String) {
		addWatcher("type", value: type, index: GraphUtility.entityIndexName, entityDescriptionName: GraphUtility.entityDescriptionName, managedObjectClassName: GraphUtility.entityObjectClassName)
	}
	
	//
	//	:name:	watch(EntityGroup)
	//
	internal func watch(EntityGroup name: String) {
		addWatcher("name", value: name, index: GraphUtility.entityGroupIndexName, entityDescriptionName: GraphUtility.entityGroupDescriptionName, managedObjectClassName: GraphUtility.entityGroupObjectClassName)
	}
	
	//
	//	:name:	watch(EntityProperty)
	//
	internal func watch(EntityProperty name: String) {
		addWatcher("name", value: name, index: GraphUtility.entityPropertyIndexName, entityDescriptionName: GraphUtility.entityPropertyDescriptionName, managedObjectClassName: GraphUtility.entityPropertyObjectClassName)
	}
	
	//
	//	:name:	watch(Action)
	//
	internal func watch(Action type: String) {
		addWatcher("type", value: type, index: GraphUtility.actionIndexName, entityDescriptionName: GraphUtility.actionDescriptionName, managedObjectClassName: GraphUtility.actionObjectClassName)
	}
	
	//
	//	:name:	watch(ActionGroup)
	//
	internal func watch(ActionGroup name: String) {
		addWatcher("name", value: name, index: GraphUtility.actionGroupIndexName, entityDescriptionName: GraphUtility.actionGroupDescriptionName, managedObjectClassName: GraphUtility.actionGroupObjectClassName)
	}
	
	//
	//	:name:	watch(ActionProperty)
	//
	internal func watch(ActionProperty name: String) {
		addWatcher("name", value: name, index: GraphUtility.actionPropertyIndexName, entityDescriptionName: GraphUtility.actionPropertyDescriptionName, managedObjectClassName: GraphUtility.actionPropertyObjectClassName)
	}
	
	//
	//	:name:	watch(Bond)
	//
	internal func watch(Bond type: String) {
		addWatcher("type", value: type, index: GraphUtility.bondIndexName, entityDescriptionName: GraphUtility.bondDescriptionName, managedObjectClassName: GraphUtility.bondObjectClassName)
	}
	
	//
	//	:name:	watch(BondGroup)
	//
	internal func watch(BondGroup name: String) {
		addWatcher("name", value: name, index: GraphUtility.bondGroupIndexName, entityDescriptionName: GraphUtility.bondGroupDescriptionName, managedObjectClassName: GraphUtility.bondGroupObjectClassName)
	}
	
	//
	//	:name:	watch(BondProperty)
	//
	internal func watch(BondProperty name: String) {
		addWatcher("name", value: name, index: GraphUtility.bondPropertyIndexName, entityDescriptionName: GraphUtility.bondPropertyDescriptionName, managedObjectClassName: GraphUtility.bondPropertyObjectClassName)
	}
	
	//
	//	:name:	managedObjectContextDidSave
	//
	internal func managedObjectContextDidSave(notification: NSNotification) {
		let userInfo: [NSObject : AnyObject]? = notification.userInfo
		
		// inserts
		if let insertedSet: NSSet = userInfo?[NSInsertedObjectsKey] as? NSSet {
			let	inserted: NSMutableSet = insertedSet.mutableCopy() as! NSMutableSet
			
			inserted.filterUsingPredicate(masterPredicate!)
			
			if 0 < inserted.count {
				for node: NSManagedObject in inserted.allObjects as! [NSManagedObject] {
					switch String.fromCString(object_getClassName(node))! {
					case "ManagedEntity_ManagedEntity_":
						delegate?.graphDidInsertEntity?(self, entity: Entity(object: node as! ManagedEntity))
					case "ManagedEntityGroup_ManagedEntityGroup_":
						let group: ManagedEntityGroup = node as! ManagedEntityGroup
						delegate?.graphDidInsertEntityGroup?(self, entity: Entity(object: group.node), group: group.name)
					case "ManagedEntityProperty_ManagedEntityProperty_":
						let property: ManagedEntityProperty = node as! ManagedEntityProperty
						delegate?.graphDidInsertEntityProperty?(self, entity: Entity(object: property.node), property: property.name, value: property.object)
					case "ManagedAction_ManagedAction_":
						delegate?.graphDidInsertAction?(self, action: Action(object: node as! ManagedAction))
					case "ManagedActionGroup_ManagedActionGroup_":
						let group: ManagedActionGroup = node as! ManagedActionGroup
						delegate?.graphDidInsertActionGroup?(self, action: Action(object: group.node), group: group.name)
					case "ManagedActionProperty_ManagedActionProperty_":
						let property: ManagedActionProperty = node as! ManagedActionProperty
						delegate?.graphDidInsertActionProperty?(self, action: Action(object: property.node), property: property.name, value: property.object)
					case "ManagedBond_ManagedBond_":
						delegate?.graphDidInsertBond?(self, bond: Bond(object: node as! ManagedBond))
					case "ManagedBondGroup_ManagedBondGroup_":
						let group: ManagedBondGroup = node as! ManagedBondGroup
						delegate?.graphDidInsertBondGroup?(self, bond: Bond(object: group.node), group: group.name)
					case "ManagedBondProperty_ManagedBondProperty_":
						let property: ManagedBondProperty = node as! ManagedBondProperty
						delegate?.graphDidInsertBondProperty?(self, bond: Bond(object: property.node), property: property.name, value: property.object)
					default:
						assert(false, "[GraphKit Error: Graph observed an object that is invalid.]")
					}
				}
			}
		}
		
		// updates
		if let updatedSet: NSSet = userInfo?[NSUpdatedObjectsKey] as? NSSet {
			let	updated: NSMutableSet = updatedSet.mutableCopy() as! NSMutableSet
			updated.filterUsingPredicate(masterPredicate!)
			
			if 0 < updated.count {
				for node: NSManagedObject in updated.allObjects as! [NSManagedObject] {
					switch String.fromCString(object_getClassName(node))! {
					case "ManagedEntityProperty_ManagedEntityProperty_":
						let property: ManagedEntityProperty = node as! ManagedEntityProperty
						delegate?.graphDidUpdateEntityProperty?(self, entity: Entity(object: property.node), property: property.name, value: property.object)
					case "ManagedActionProperty_ManagedActionProperty_":
						let property: ManagedActionProperty = node as! ManagedActionProperty
						delegate?.graphDidUpdateActionProperty?(self, action: Action(object: property.node), property: property.name, value: property.object)
					case "ManagedBondProperty_ManagedBondProperty_":
						let property: ManagedBondProperty = node as! ManagedBondProperty
						delegate?.graphDidUpdateBondProperty?(self, bond: Bond(object: property.node), property: property.name, value: property.object)
					case "ManagedAction_ManagedAction_":
						delegate?.graphDidUpdateAction?(self, action: Action(object: node as! ManagedAction))
					default:
						assert(false, "[GraphKit Error: Graph observed an object that is invalid.]")
					}
				}
			}
		}
		
		// deletes
		if let deletedSet: NSSet = userInfo?[NSDeletedObjectsKey] as? NSSet {
			let	deleted: NSMutableSet = deletedSet.mutableCopy() as! NSMutableSet
			deleted.filterUsingPredicate(masterPredicate!)
			
			if 0 < deleted.count {
				for node: NSManagedObject in deleted.allObjects as! [NSManagedObject] {
					switch String.fromCString(object_getClassName(node))! {
					case "ManagedEntity_ManagedEntity_":
						delegate?.graphDidDeleteEntity?(self, entity: Entity(object: node as! ManagedEntity))
					case "ManagedEntityProperty_ManagedEntityProperty_":
						let property: ManagedEntityProperty = node as! ManagedEntityProperty
						delegate?.graphDidDeleteEntityProperty?(self, entity: Entity(object: property.node), property: property.name, value: property.object)
					case "ManagedEntityGroup_ManagedEntityGroup_":
						let group: ManagedEntityGroup = node as! ManagedEntityGroup
						delegate?.graphDidDeleteEntityGroup?(self, entity: Entity(object: group.node), group: group.name)
					case "ManagedAction_ManagedAction_":
						delegate?.graphDidDeleteAction?(self, action: Action(object: node as! ManagedAction))
					case "ManagedActionProperty_ManagedActionProperty_":
						let property: ManagedActionProperty = node as! ManagedActionProperty
						delegate?.graphDidDeleteActionProperty?(self, action: Action(object: property.node), property: property.name, value: property.object)
					case "ManagedActionGroup_ManagedActionGroup_":
						let group: ManagedActionGroup = node as! ManagedActionGroup
						delegate?.graphDidDeleteActionGroup?(self, action: Action(object: group.node), group: group.name)
					case "ManagedBond_ManagedBond_":
						delegate?.graphDidDeleteBond?(self, bond: Bond(object: node as! ManagedBond))
					case "ManagedBondProperty_ManagedBondProperty_":
						let property: ManagedBondProperty = node as! ManagedBondProperty
						delegate?.graphDidDeleteBondProperty?(self, bond: Bond(object: property.node), property: property.name, value: property.object)
					case "ManagedBondGroup_ManagedBondGroup_":
						let group: ManagedBondGroup = node as! ManagedBondGroup
						delegate?.graphDidDeleteBondGroup?(self, bond: Bond(object: group.node), group: group.name)
					default:
						assert(false, "[GraphKit Error: Graph observed an object that is invalid.]")
					}
				}
			}
		}
	}
	
	//
	//	:name:	prepareForObservation
	//
	internal func prepareForObservation() {
		NSNotificationCenter.defaultCenter().removeObserver(self)
		NSNotificationCenter.defaultCenter().removeObserver(self, name: NSManagedObjectContextDidSaveNotification, object: worker)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "managedObjectContextDidSave:", name: NSManagedObjectContextDidSaveNotification, object: worker)
	}
	
	//
	//	:name:	addPredicateToObserve
	//
	internal func addPredicateToObserve(entityDescription: NSEntityDescription, predicate: NSPredicate) {
		let entityPredicate: NSPredicate = NSPredicate(format: "entity.name == %@", entityDescription.name! as NSString)
		let predicates: Array<NSPredicate> = [entityPredicate, predicate]
		let finalPredicate: NSPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
		masterPredicate = nil == masterPredicate ? finalPredicate : NSCompoundPredicate(orPredicateWithSubpredicates: [masterPredicate!, finalPredicate])
	}
	
	//
	//	:name:	isWatching
	//
	internal func isWatching(key: String, index: String) -> Bool {
		if nil == watchers[key] {
			watchers[key] = Array<String>(arrayLiteral: index)
			return false
		}
		if watchers[key]!.contains(index) {
			return true
		}
		watchers[key]!.append(index)
		return false
	}
	
	//
	//	:name:	addWatcher
	//
	internal func addWatcher(key: String, value: String, index: String, entityDescriptionName: String, managedObjectClassName: String) {
		if !isWatching(value, index: index) {
			let entityDescription: NSEntityDescription = NSEntityDescription()
			entityDescription.name = entityDescriptionName
			entityDescription.managedObjectClassName = managedObjectClassName
			let predicate: NSPredicate = NSPredicate(format: "%K LIKE %@", key as NSString, value as NSString)
			addPredicateToObserve(entityDescription, predicate: predicate)
			prepareForObservation()
		}
	}
}