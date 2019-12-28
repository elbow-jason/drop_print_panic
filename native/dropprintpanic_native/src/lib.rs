use rustler::ResourceArc;
use rustler::{Encoder, Env, NifStruct, Term};

mod atoms {
    rustler::atoms! {
        ok,
    }
}

rustler::init! {
    "Elixir.DropPrintPanic.Native",
    [
        new_panicker,
        panicker_name,

        new_non_panicker,
        non_panicker_name,

    ],
    load = load
}

fn load<'a>(env: Env<'a>, _load_info: Term<'a>) -> bool {
    rustler::resource!(Wrapper<NamedThing>, env);
    true
}

struct NamedThing {
    name: String,
}

impl NamedThing {
    fn new(name: String) -> NamedThing {
        NamedThing { name }
    }
}

struct Wrapper<T> {
    wrapped: T,
}

impl<T> Wrapper<T> {
    fn new(wrapped: T) -> Wrapper<T> {
        Wrapper { wrapped }
    }
}

#[derive(NifStruct)]
#[must_use]
#[module = "DropPrintPanic.Panicker"]
#[repr(C)]
pub struct Panicker {
    __native__: ResourceArc<Wrapper<NamedThing>>,
    _unconstructable: (),
}

impl Panicker {
    pub fn new(name: String) -> Panicker {
        Panicker {
            __native__: ResourceArc::new(Wrapper::new(NamedThing::new(name))),
            _unconstructable: (),
        }
    }
}

impl Drop for Panicker {
    fn drop(&mut self) {
        println!("This should cause a panic eventually...\r");
        println!("This should cause a panic eventually...\r");
        println!("This should cause a panic eventually...\r");
        println!("This should cause a panic eventually...\r");
        println!("This should cause a panic eventually...\r");
    }
}

#[derive(NifStruct)]
#[must_use]
#[module = "DropPrintPanic.NonPanicker"]
#[repr(C)]
pub struct NonPanicker {
    __native__: ResourceArc<Wrapper<NamedThing>>,
    _unconstructable: (),
}

impl NonPanicker {
    pub fn new(name: String) -> NonPanicker {
        NonPanicker {
            __native__: ResourceArc::new(Wrapper::new(NamedThing::new(name))),
            _unconstructable: (),
        }
    }
}

impl Drop for NonPanicker {
    fn drop(&mut self) {
        let sleep_for = std::time::Duration::from_nanos(1);
        std::thread::sleep(sleep_for);
    }
}

#[rustler::nif]
fn new_panicker(name: String) -> Panicker {
    Panicker::new(name)
}

#[rustler::nif]
fn panicker_name<'a>(panicker: Panicker) -> String {
    panicker.__native__.wrapped.name.clone()
}

#[rustler::nif]
fn new_non_panicker(name: String) -> NonPanicker {
    NonPanicker::new(name)
}

#[rustler::nif]
fn non_panicker_name<'a>(non_panicker: NonPanicker) -> String {
    non_panicker.__native__.wrapped.name.clone()
}
