# Dynamic Objects in C#

[From...](http://www.sullinger.us/blog/2014/1/6/create-objects-dynamically-in-c).

The class `ExpandoObject` inherits from IDicitionary, which provides a lot of usefulness....

```csharp
    public class DynamicRow
    {
        public dynamic Instance = new ExpandoObject();
        
        public void AddProperty(string name, object value = null)
            => ((IDictionary<string, object>)this.Instance).Add(name, value);

        public void UpdateProperty(string propertyName, object value)
            => ((IDictionary<string, object>)this.Instance)[propertyName] = value;
                
        public dynamic GetProperty(string name)
        {
            if (((IDictionary<string, object>)this.Instance).ContainsKey(name))
                return ((IDictionary<string, object>)this.Instance)[name];
            else
                return null;
        }
        
        public void RemoveProperty(string name)
        {
          if (((IDictionary<string, object>)this.Instance).ContainsKey(name))
            ((IDictionary<string, object>)this.Instance).Remove(name, value);
        }
    }
```

Then you can map it to a static typed object when needed:

```csharp
    [AttributeUsage(AttributeTargets.Property, AllowMultiple = true, Inherited = true)]
    public sealed class FromDynamicColumn : System.Attribute
    {
        private readonly string _name;
        public FromDynamicColumn(string name)
            => _name = name;
        public string Name { get { return _name; } }
    }
```

```csharp
        public static TObject MapToObject<TObject>(
            this IDictionary<string, object> sourceObject, 
            BindingFlags bindingFlags = BindingFlags.Instance | BindingFlags.Public
        )
            where TObject : class, new()
        {
            Contract.Requires(sourceObject != null);
            TObject targetObject = new TObject();
            Type targetObjectType = typeof(TObject);
            PropertyInfo[] propertyInfos = targetObjectType.GetProperties(bindingFlags);
            foreach (PropertyInfo property in propertyInfos)
            {
                FromDynamicColumn fromDynamicColumn = property.GetCustomAttribute<FromDynamicColumn>();

                if (sourceObject.ContainsKey(fromDynamicColumn.Name))
                {
                    var val = sourceObject[fromDynamicColumn.Name];
                    if (val != null)
                        property.SetValue(targetObject, val);
                }                  
            }
            return targetObject;
        }
```

Then call the mapping method like this:
```csharp
DynamicRow myDynamicObject = new DynamicRow().AddProperty("User", new User());

MyStaticType staticUser = MappingUtil.MapToObject<MyStaticType>(dynamicObject.Instance);
```
