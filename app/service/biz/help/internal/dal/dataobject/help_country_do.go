/*
 * WARNING! All changes made in this file will be lost!
 *   Created from by 'dalgen'
 *
 * Copyright (c) 2024-present,  Teamgram Authors.
 *  All rights reserved.
 *
 * Author: teamgramio (teamgram.io@gmail.com)
 */

package dataobject

type HelpCountryDO struct {
	Id          int64  `db:"id" json:"id"`
	Hidden      bool   `db:"hidden" json:"hidden"`
	Iso2        string `db:"iso2" json:"iso2"`
	DefaultName string `db:"default_name" json:"default_name"`
	Name        string `db:"name" json:"name"`
	CountryCode int32  `db:"country_code" json:"country_code"`
	Prefixes    string `db:"prefixes" json:"prefixes"` // JSON string
	Patterns    string `db:"patterns" json:"patterns"` // JSON string
	CreatedAt   string `db:"created_at" json:"created_at"`
	UpdatedAt   string `db:"updated_at" json:"updated_at"`
}
