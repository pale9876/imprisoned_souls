use godot::prelude::*;
use oauth2::*;
use url::Url;
use std::{env, net::TcpListener};




#[derive(GodotClass)]
#[class(base=RefCounted, no_init)]
pub struct GodotSeeMe
{
    client_id: String,
    secret: String,
    base_url: String,

}


const BASE_URL: &str = "https://ci.me/api/openapi";
const SECRET: &str = "pwN8BkQmM6EOqdHYwFPOFuOkSKZt/oQAfWHXw/kNEKE=";
const CLIENTID: &str = "56695e67-fc00-4d9b-9a8c-6147223593f4";

#[godot_api]
impl GodotSeeMe
{

    #[func]
    fn start(&mut self)
    {
        

    }


}