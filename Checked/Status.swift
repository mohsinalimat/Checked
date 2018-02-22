//
//  Section.swift
//  Checked
//
//  Created by Roman Subrychak on 2/8/18.
//  Copyright © 2018 Roman Subrychak. All rights reserved.
//

import Foundation

enum Status: Int {
	case active
	case finished
	
	var description: String {
		switch self {
		case .active:
			return "Active"
		case .finished:
			return "Finished"
		}
	}
}
