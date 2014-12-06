//
//  main.swift
//  color-tool
//
//  Created by Markus Gasser on 06.12.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

import Foundation


Log.applicationName = Process.arguments[0].lastPathComponent

let manager = Manager()

manager.register(CreateColorListCommand())

manager.register("create-clr", "Create an Apple color list (.clr)") { argv in
    CreateColorListCommand().run(argv)
}

manager.run()
