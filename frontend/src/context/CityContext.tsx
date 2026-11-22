import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';

export interface CityInfo {
  name: string;
  state: string;
  tagline: string;
  temp: number;
  weather: string;
  image: string;
  authorityName: string;
  stats: {
    total: number;
    resolved: number;
    avgHours: string;
    trendTotal: string;
    trendResolved: string;
    trendAvg: string;
  };
  popularIssues: {
    category: string;
    count: number;
    percentage: number;
    color: string;
    iconType: string;
  }[];
  recentUpdates: {
    id: string;
    title: string;
    timeAgo: string;
    status: 'Resolved' | 'In Progress' | 'Completed';
    badgeColor: string;
  }[];
  mapCenter: [number, number];
  mapIssues: {
    id: string;
    title: string;
    category: string;
    status: 'open' | 'in_progress' | 'resolved';
    location: string;
    x: number; // percentage in relative map canvas
    y: number;
    timeAgo: string;
  }[];
}

const CITY_DATABASE: Record<string, CityInfo> = {
  'New Delhi': {
    name: 'New Delhi',
    state: 'Delhi',
    tagline: 'Capital • Dynamic • Resilient',
    temp: 26,
    weather: 'Sunny',
    image: 'https://images.unsplash.com/photo-1587474260584-136574528ed5?w=800&auto=format&fit=crop&q=80',
    authorityName: 'Municipal Corporation of Delhi (MCD)',
    stats: {
      total: 42,
      resolved: 29,
      avgHours: '< 28h',
      trendTotal: '↑ 14%',
      trendResolved: '↑ 32%',
      trendAvg: '↓ 12%',
    },
    popularIssues: [
      { category: 'Pothole / Road Damage', count: 58, percentage: 80, color: '#EF4444', iconType: 'pothole' },
      { category: 'Garbage / Waste', count: 38, percentage: 55, color: '#10B981', iconType: 'garbage' },
      { category: 'Streetlight', count: 24, percentage: 38, color: '#F59E0B', iconType: 'streetlight' },
      { category: 'Water Leakage', count: 19, percentage: 28, color: '#0284C7', iconType: 'water' },
      { category: 'Drainage', count: 14, percentage: 22, color: '#6366F1', iconType: 'drainage' },
      { category: 'Other Issues', count: 9, percentage: 14, color: '#A855F7', iconType: 'other' },
    ],
    recentUpdates: [
      { id: 'u1', title: 'Road repair on Outer Ring Road completed.', timeAgo: '1 hour ago', status: 'Resolved', badgeColor: 'bg-emerald-50 text-emerald-600 border-emerald-100' },
      { id: 'u2', title: 'Waste collection drive underway in Sector 14.', timeAgo: '3 hours ago', status: 'In Progress', badgeColor: 'bg-amber-50 text-amber-600 border-amber-100' },
      { id: 'u3', title: 'Modern LED smart lights installed along Main Avenue.', timeAgo: '5 hours ago', status: 'Completed', badgeColor: 'bg-emerald-50 text-emerald-600 border-emerald-100' },
      { id: 'u4', title: 'Drainage desilting scheduled for Zone 4.', timeAgo: '7 hours ago', status: 'In Progress', badgeColor: 'bg-amber-50 text-amber-600 border-amber-100' },
      { id: 'u5', title: 'Community park cleaning drive finished.', timeAgo: '9 hours ago', status: 'Resolved', badgeColor: 'bg-emerald-50 text-emerald-600 border-emerald-100' },
    ],
    mapCenter: [28.6139, 77.2090],
    mapIssues: [
      { id: 'NS9201', title: 'Pothole on Connaught Outer Circle', category: 'Pothole', status: 'open', location: 'Connaught Place', x: 45, y: 35, timeAgo: '2h ago' },
      { id: 'NS9202', title: 'Overflowing bin near Market Gate 3', category: 'Garbage', status: 'open', location: 'Lajpat Nagar', x: 62, y: 58, timeAgo: '4h ago' },
      { id: 'NS9203', title: 'Streetlight pole dark on Avenue Rd', category: 'Streetlight', status: 'in_progress', location: 'Saket Sector 2', x: 38, y: 72, timeAgo: '5h ago' },
      { id: 'NS9204', title: 'Underground pipeline leakage', category: 'Water Leakage', status: 'open', location: 'Karol Bagh', x: 28, y: 40, timeAgo: '8h ago' },
      { id: 'NS9205', title: 'Asphalt resurfaced & leveled', category: 'Pothole', status: 'resolved', location: 'Dwarka Sector 9', x: 55, y: 25, timeAgo: '1d ago' },
      { id: 'NS9206', title: 'Stormwater drain cleared', category: 'Drainage', status: 'resolved', location: 'Mayur Vihar Ph 1', x: 70, y: 65, timeAgo: '1d ago' },
    ],
  },

  'Mumbai': {
    name: 'Mumbai',
    state: 'Maharashtra',
    tagline: 'Coastal • Energetic • Progressive',
    temp: 30,
    weather: 'Humid & Sunny',
    image: 'https://images.unsplash.com/photo-1570168007204-dfb528c6958f?w=800&auto=format&fit=crop&q=80',
    authorityName: 'Brihanmumbai Municipal Corporation (BMC)',
    stats: {
      total: 56,
      resolved: 41,
      avgHours: '< 32h',
      trendTotal: '↑ 18%',
      trendResolved: '↑ 28%',
      trendAvg: '↓ 15%',
    },
    popularIssues: [
      { category: 'Pothole / Road Damage', count: 64, percentage: 85, color: '#EF4444', iconType: 'pothole' },
      { category: 'Water Leakage', count: 42, percentage: 60, color: '#0284C7', iconType: 'water' },
      { category: 'Drainage', count: 35, percentage: 50, color: '#6366F1', iconType: 'drainage' },
      { category: 'Garbage / Waste', count: 28, percentage: 40, color: '#10B981', iconType: 'garbage' },
      { category: 'Streetlight', count: 18, percentage: 25, color: '#F59E0B', iconType: 'streetlight' },
      { category: 'Other Issues', count: 12, percentage: 18, color: '#A855F7', iconType: 'other' },
    ],
    recentUpdates: [
      { id: 'm1', title: 'Pothole filled near Western Express Highway.', timeAgo: '1 hour ago', status: 'Resolved', badgeColor: 'bg-emerald-50 text-emerald-600 border-emerald-100' },
      { id: 'm2', title: 'Pipeline repair underway at Bandra West.', timeAgo: '2 hours ago', status: 'In Progress', badgeColor: 'bg-amber-50 text-amber-600 border-amber-100' },
      { id: 'm3', title: 'Monsoon drain clearing completed in Dadar.', timeAgo: '4 hours ago', status: 'Completed', badgeColor: 'bg-emerald-50 text-emerald-600 border-emerald-100' },
      { id: 'm4', title: 'Streetlight pole fixed on Link Road.', timeAgo: '6 hours ago', status: 'Resolved', badgeColor: 'bg-emerald-50 text-emerald-600 border-emerald-100' },
      { id: 'm5', title: 'Beach cleanliness drive ongoing in Juhu.', timeAgo: '8 hours ago', status: 'In Progress', badgeColor: 'bg-amber-50 text-amber-600 border-amber-100' },
    ],
    mapCenter: [19.0760, 72.8777],
    mapIssues: [
      { id: 'NS8101', title: 'Asphalt wear and pothole on flyover', category: 'Pothole', status: 'open', location: 'Andheri West', x: 42, y: 32, timeAgo: '1h ago' },
      { id: 'NS8102', title: 'High pressure water pipe leak', category: 'Water Leakage', status: 'in_progress', location: 'Bandra Reclamation', x: 50, y: 52, timeAgo: '3h ago' },
      { id: 'NS8103', title: 'Drain cover displaced', category: 'Drainage', status: 'open', location: 'Dadar Central', x: 60, y: 68, timeAgo: '4h ago' },
      { id: 'NS8104', title: 'Street light out on promenade', category: 'Streetlight', status: 'resolved', location: 'Marine Drive', x: 32, y: 80, timeAgo: '1d ago' },
      { id: 'NS8105', title: 'Waste cleared from corner plot', category: 'Garbage', status: 'resolved', location: 'Kurla West', x: 65, y: 40, timeAgo: '1d ago' },
    ],
  },

  'Bengaluru': {
    name: 'Bengaluru',
    state: 'Karnataka',
    tagline: 'Tech Capital • Green • Vibrant',
    temp: 24,
    weather: 'Pleasant & Breezy',
    image: 'https://images.unsplash.com/photo-1596176530529-78163a4f7af2?w=800&auto=format&fit=crop&q=80',
    authorityName: 'Bruhat Bengaluru Mahanagara Palike (BBMP)',
    stats: {
      total: 38,
      resolved: 27,
      avgHours: '< 29h',
      trendTotal: '↑ 11%',
      trendResolved: '↑ 24%',
      trendAvg: '↓ 16%',
    },
    popularIssues: [
      { category: 'Pothole / Road Damage', count: 48, percentage: 76, color: '#EF4444', iconType: 'pothole' },
      { category: 'Streetlight', count: 32, percentage: 52, color: '#F59E0B', iconType: 'streetlight' },
      { category: 'Garbage / Waste', count: 26, percentage: 42, color: '#10B981', iconType: 'garbage' },
      { category: 'Drainage', count: 20, percentage: 32, color: '#6366F1', iconType: 'drainage' },
      { category: 'Water Leakage', count: 15, percentage: 24, color: '#0284C7', iconType: 'water' },
      { category: 'Other Issues', count: 8, percentage: 12, color: '#A855F7', iconType: 'other' },
    ],
    recentUpdates: [
      { id: 'b1', title: 'Pothole filled on 100ft Road Indiranagar.', timeAgo: '45 mins ago', status: 'Resolved', badgeColor: 'bg-emerald-50 text-emerald-600 border-emerald-100' },
      { id: 'b2', title: 'Dry waste segregation unit deployed in Koramangala.', timeAgo: '3 hours ago', status: 'Completed', badgeColor: 'bg-emerald-50 text-emerald-600 border-emerald-100' },
      { id: 'b3', title: 'Underground optical cable ditch leveled in HSR.', timeAgo: '5 hours ago', status: 'In Progress', badgeColor: 'bg-amber-50 text-amber-600 border-amber-100' },
      { id: 'b4', title: 'Streetlight sensor replacement in Whitefield.', timeAgo: '7 hours ago', status: 'In Progress', badgeColor: 'bg-amber-50 text-amber-600 border-amber-100' },
      { id: 'b5', title: 'Lake boundary debris cleared near Bellandur.', timeAgo: '10 hours ago', status: 'Resolved', badgeColor: 'bg-emerald-50 text-emerald-600 border-emerald-100' },
    ],
    mapCenter: [12.9716, 77.5946],
    mapIssues: [
      { id: 'NS7301', title: 'Deep trench on 80ft Road junction', category: 'Pothole', status: 'open', location: 'Koramangala 4th Block', x: 48, y: 58, timeAgo: '2h ago' },
      { id: 'NS7302', title: 'Flickering street LED fixtures', category: 'Streetlight', status: 'in_progress', location: 'HSR Layout Sector 1', x: 62, y: 70, timeAgo: '3h ago' },
      { id: 'NS7303', title: 'Commercial waste uncollected', category: 'Garbage', status: 'open', location: 'Indiranagar 12th Main', x: 55, y: 38, timeAgo: '5h ago' },
      { id: 'NS7304', title: 'Water pipe rupture on service road', category: 'Water Leakage', status: 'resolved', location: 'Electronic City Phase 1', x: 68, y: 82, timeAgo: '1d ago' },
      { id: 'NS7305', title: 'Footpath paving slabs restored', category: 'Pothole', status: 'resolved', location: 'MG Road Metro Station', x: 38, y: 42, timeAgo: '1d ago' },
    ],
  },

  'Hyderabad': {
    name: 'Hyderabad',
    state: 'Telangana',
    tagline: 'Historic • Cyber City • Smart',
    temp: 29,
    weather: 'Sunny',
    image: 'https://images.unsplash.com/photo-1605649487212-47bdab064df7?w=800&auto=format&fit=crop&q=80',
    authorityName: 'Greater Hyderabad Municipal Corporation (GHMC)',
    stats: {
      total: 31,
      resolved: 22,
      avgHours: '< 27h',
      trendTotal: '↑ 9%',
      trendResolved: '↑ 26%',
      trendAvg: '↓ 14%',
    },
    popularIssues: [
      { category: 'Pothole / Road Damage', count: 39, percentage: 70, color: '#EF4444', iconType: 'pothole' },
      { category: 'Streetlight', count: 28, percentage: 50, color: '#F59E0B', iconType: 'streetlight' },
      { category: 'Water Leakage', count: 22, percentage: 39, color: '#0284C7', iconType: 'water' },
      { category: 'Garbage / Waste', count: 19, percentage: 34, color: '#10B981', iconType: 'garbage' },
      { category: 'Drainage', count: 14, percentage: 25, color: '#6366F1', iconType: 'drainage' },
      { category: 'Other Issues', count: 7, percentage: 12, color: '#A855F7', iconType: 'other' },
    ],
    recentUpdates: [
      { id: 'h1', title: 'Road repair in Hitec City completed.', timeAgo: '1 hour ago', status: 'Resolved', badgeColor: 'bg-emerald-50 text-emerald-600 border-emerald-100' },
      { id: 'h2', title: 'Water pipeline maintenance in Jubilee Hills.', timeAgo: '4 hours ago', status: 'In Progress', badgeColor: 'bg-amber-50 text-amber-600 border-amber-100' },
      { id: 'h3', title: 'Streetlight replacement drive in Gachibowli.', timeAgo: '6 hours ago', status: 'Completed', badgeColor: 'bg-emerald-50 text-emerald-600 border-emerald-100' },
      { id: 'h4', title: 'Sanitation sweep finished at Charminar area.', timeAgo: '8 hours ago', status: 'Resolved', badgeColor: 'bg-emerald-50 text-emerald-600 border-emerald-100' },
    ],
    mapCenter: [17.3850, 78.4867],
    mapIssues: [
      { id: 'NS6101', title: 'Damaged speed breaker on Cyber Towers Rd', category: 'Pothole', status: 'open', location: 'Madhapur', x: 42, y: 44, timeAgo: '2h ago' },
      { id: 'NS6102', title: 'Streetlight timer out of sync', category: 'Streetlight', status: 'in_progress', location: 'Banjara Hills Rd 12', x: 50, y: 55, timeAgo: '3h ago' },
      { id: 'NS6103', title: 'Garbage point cleared', category: 'Garbage', status: 'resolved', location: 'Secunderabad Stn Rd', x: 65, y: 35, timeAgo: '1d ago' },
      { id: 'NS6104', title: 'Water leakage patched on main pipe', category: 'Water Leakage', status: 'resolved', location: 'Kukatpally Phase 2', x: 30, y: 30, timeAgo: '1d ago' },
    ],
  },

  'Chennai': {
    name: 'Chennai',
    state: 'Tamil Nadu',
    tagline: 'Coastal • Cultural • Progressive',
    temp: 31,
    weather: 'Humid & Clear',
    image: 'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?w=800&auto=format&fit=crop&q=80',
    authorityName: 'Greater Chennai Corporation (GCC)',
    stats: {
      total: 35,
      resolved: 26,
      avgHours: '< 30h',
      trendTotal: '↑ 12%',
      trendResolved: '↑ 20%',
      trendAvg: '↓ 10%',
    },
    popularIssues: [
      { category: 'Drainage', count: 44, percentage: 75, color: '#6366F1', iconType: 'drainage' },
      { category: 'Pothole / Road Damage', count: 36, percentage: 62, color: '#EF4444', iconType: 'pothole' },
      { category: 'Garbage / Waste', count: 24, percentage: 41, color: '#10B981', iconType: 'garbage' },
      { category: 'Streetlight', count: 18, percentage: 31, color: '#F59E0B', iconType: 'streetlight' },
      { category: 'Water Leakage', count: 14, percentage: 24, color: '#0284C7', iconType: 'water' },
      { category: 'Other Issues', count: 8, percentage: 14, color: '#A855F7', iconType: 'other' },
    ],
    recentUpdates: [
      { id: 'c1', title: 'Stormwater canal cleaned in T. Nagar.', timeAgo: '2 hours ago', status: 'Resolved', badgeColor: 'bg-emerald-50 text-emerald-600 border-emerald-100' },
      { id: 'c2', title: 'Road resurfaced near Anna Salai.', timeAgo: '4 hours ago', status: 'Completed', badgeColor: 'bg-emerald-50 text-emerald-600 border-emerald-100' },
      { id: 'c3', title: 'Garbage bins sanitized in Mylapore.', timeAgo: '6 hours ago', status: 'Resolved', badgeColor: 'bg-emerald-50 text-emerald-600 border-emerald-100' },
    ],
    mapCenter: [13.0827, 80.2707],
    mapIssues: [
      { id: 'NS5101', title: 'Blocked culvert on Arcot Road', category: 'Drainage', status: 'open', location: 'Vadapalani', x: 44, y: 50, timeAgo: '2h ago' },
      { id: 'NS5102', title: 'Road crater near flyover base', category: 'Pothole', status: 'in_progress', location: 'Guindy Industrial Estate', x: 52, y: 65, timeAgo: '4h ago' },
      { id: 'NS5103', title: 'Streetlight repaired', category: 'Streetlight', status: 'resolved', location: 'Besant Nagar Beach Rd', x: 68, y: 75, timeAgo: '1d ago' },
    ],
  },

  'Kolkata': {
    name: 'Kolkata',
    state: 'West Bengal',
    tagline: 'Heritage • Cultural • Riverine',
    temp: 27,
    weather: 'Pleasant & Mild',
    image: 'https://images.unsplash.com/photo-1558431382-27e303142255?w=800&auto=format&fit=crop&q=80',
    authorityName: 'Kolkata Municipal Corporation (KMC)',
    stats: {
      total: 29,
      resolved: 20,
      avgHours: '< 33h',
      trendTotal: '↑ 8%',
      trendResolved: '↑ 19%',
      trendAvg: '↓ 8%',
    },
    popularIssues: [
      { category: 'Pothole / Road Damage', count: 32, percentage: 65, color: '#EF4444', iconType: 'pothole' },
      { category: 'Drainage', count: 28, percentage: 56, color: '#6366F1', iconType: 'drainage' },
      { category: 'Garbage / Waste', count: 22, percentage: 44, color: '#10B981', iconType: 'garbage' },
      { category: 'Streetlight', count: 16, percentage: 32, color: '#F59E0B', iconType: 'streetlight' },
      { category: 'Water Leakage', count: 11, percentage: 22, color: '#0284C7', iconType: 'water' },
      { category: 'Other Issues', count: 6, percentage: 12, color: '#A855F7', iconType: 'other' },
    ],
    recentUpdates: [
      { id: 'k1', title: 'Tram track asphalt repaired at College Street.', timeAgo: '2 hours ago', status: 'Resolved', badgeColor: 'bg-emerald-50 text-emerald-600 border-emerald-100' },
      { id: 'k2', title: 'Waste removal from Park Street market.', timeAgo: '5 hours ago', status: 'Completed', badgeColor: 'bg-emerald-50 text-emerald-600 border-emerald-100' },
    ],
    mapCenter: [22.5726, 88.3639],
    mapIssues: [
      { id: 'NS4101', title: 'Open drain near metro gate', category: 'Drainage', status: 'open', location: 'Salt Lake Sector 5', x: 62, y: 38, timeAgo: '2h ago' },
      { id: 'NS4102', title: 'Pothole fixed near Howrah Bridge approach', category: 'Pothole', status: 'resolved', location: 'Strand Road', x: 35, y: 45, timeAgo: '1d ago' },
    ],
  },

  'Pune': {
    name: 'Pune',
    state: 'Maharashtra',
    tagline: 'Education • Tech • Green City',
    temp: 26,
    weather: 'Clear & Sunny',
    image: 'https://images.unsplash.com/photo-1595658658481-d53d3f999875?w=800&auto=format&fit=crop&q=80',
    authorityName: 'Pune Municipal Corporation (PMC)',
    stats: {
      total: 33,
      resolved: 24,
      avgHours: '< 28h',
      trendTotal: '↑ 10%',
      trendResolved: '↑ 23%',
      trendAvg: '↓ 14%',
    },
    popularIssues: [
      { category: 'Pothole / Road Damage', count: 37, percentage: 72, color: '#EF4444', iconType: 'pothole' },
      { category: 'Streetlight', count: 25, percentage: 48, color: '#F59E0B', iconType: 'streetlight' },
      { category: 'Garbage / Waste', count: 20, percentage: 39, color: '#10B981', iconType: 'garbage' },
      { category: 'Water Leakage', count: 16, percentage: 31, color: '#0284C7', iconType: 'water' },
      { category: 'Drainage', count: 12, percentage: 23, color: '#6366F1', iconType: 'drainage' },
      { category: 'Other Issues', count: 6, percentage: 12, color: '#A855F7', iconType: 'other' },
    ],
    recentUpdates: [
      { id: 'p1', title: 'FC Road pedestrian pavement leveling completed.', timeAgo: '1 hour ago', status: 'Resolved', badgeColor: 'bg-emerald-50 text-emerald-600 border-emerald-100' },
      { id: 'p2', title: 'Streetlight drive in Baner Sector 3.', timeAgo: '4 hours ago', status: 'In Progress', badgeColor: 'bg-amber-50 text-amber-600 border-amber-100' },
    ],
    mapCenter: [18.5204, 73.8567],
    mapIssues: [
      { id: 'NS3101', title: 'Deep crater on Hinjewadi Phase 1 road', category: 'Pothole', status: 'open', location: 'Hinjewadi', x: 35, y: 35, timeAgo: '1h ago' },
      { id: 'NS3102', title: 'Streetlight sensor repaired', category: 'Streetlight', status: 'resolved', location: 'Kothrud Stand', x: 45, y: 60, timeAgo: '1d ago' },
    ],
  },

  'Jaipur': {
    name: 'Jaipur',
    state: 'Rajasthan',
    tagline: 'Pink City • Heritage • Clean',
    temp: 28,
    weather: 'Sunny & Bright',
    image: 'https://images.unsplash.com/photo-1599818818833-c28892d3b25f?w=800&auto=format&fit=crop&q=80',
    authorityName: 'Jaipur Nagar Nigam (Greater & Heritage)',
    stats: {
      total: 26,
      resolved: 19,
      avgHours: '< 31h',
      trendTotal: '↑ 7%',
      trendResolved: '↑ 18%',
      trendAvg: '↓ 11%',
    },
    popularIssues: [
      { category: 'Pothole / Road Damage', count: 28, percentage: 68, color: '#EF4444', iconType: 'pothole' },
      { category: 'Garbage / Waste', count: 22, percentage: 53, color: '#10B981', iconType: 'garbage' },
      { category: 'Streetlight', count: 18, percentage: 43, color: '#F59E0B', iconType: 'streetlight' },
      { category: 'Water Leakage', count: 12, percentage: 29, color: '#0284C7', iconType: 'water' },
      { category: 'Drainage', count: 8, percentage: 19, color: '#6366F1', iconType: 'drainage' },
      { category: 'Other Issues', count: 5, percentage: 12, color: '#A855F7', iconType: 'other' },
    ],
    recentUpdates: [
      { id: 'j1', title: 'Bazaar heritage facade waste cleared.', timeAgo: '2 hours ago', status: 'Resolved', badgeColor: 'bg-emerald-50 text-emerald-600 border-emerald-100' },
      { id: 'j2', title: 'Road leveling done near MI Road.', timeAgo: '5 hours ago', status: 'Completed', badgeColor: 'bg-emerald-50 text-emerald-600 border-emerald-100' },
    ],
    mapCenter: [26.9124, 75.7873],
    mapIssues: [
      { id: 'NS2101', title: 'Damaged stone curb on JLN Marg', category: 'Pothole', status: 'open', location: 'JLN Marg', x: 50, y: 55, timeAgo: '3h ago' },
      { id: 'NS2102', title: 'Streetlight fixed near Albert Hall', category: 'Streetlight', status: 'resolved', location: 'Ram Niwas Garden', x: 48, y: 42, timeAgo: '1d ago' },
    ],
  },

  'Chandigarh': {
    name: 'Chandigarh',
    state: 'Punjab & Haryana',
    tagline: 'Planned • Clean • The City Beautiful',
    temp: 23,
    weather: 'Clear & Crisp',
    image: 'https://images.unsplash.com/photo-1597040663342-45b6af3d91a5?w=800&auto=format&fit=crop&q=80',
    authorityName: 'Municipal Corporation Chandigarh (MCC)',
    stats: {
      total: 18,
      resolved: 15,
      avgHours: '< 22h',
      trendTotal: '↑ 5%',
      trendResolved: '↑ 30%',
      trendAvg: '↓ 20%',
    },
    popularIssues: [
      { category: 'Streetlight', count: 19, percentage: 60, color: '#F59E0B', iconType: 'streetlight' },
      { category: 'Pothole / Road Damage', count: 16, percentage: 50, color: '#EF4444', iconType: 'pothole' },
      { category: 'Garbage / Waste', count: 12, percentage: 38, color: '#10B981', iconType: 'garbage' },
      { category: 'Water Leakage', count: 8, percentage: 25, color: '#0284C7', iconType: 'water' },
      { category: 'Drainage', count: 6, percentage: 19, color: '#6366F1', iconType: 'drainage' },
      { category: 'Other Issues', count: 4, percentage: 12, color: '#A855F7', iconType: 'other' },
    ],
    recentUpdates: [
      { id: 'ch1', title: 'Roundabout landscaping and curb repaired.', timeAgo: '3 hours ago', status: 'Completed', badgeColor: 'bg-emerald-50 text-emerald-600 border-emerald-100' },
      { id: 'ch2', title: 'Sector 17 Plaza lighting upgraded.', timeAgo: '6 hours ago', status: 'Resolved', badgeColor: 'bg-emerald-50 text-emerald-600 border-emerald-100' },
    ],
    mapCenter: [30.7333, 76.7794],
    mapIssues: [
      { id: 'NS1101', title: 'Cycle track pavement patch required', category: 'Pothole', status: 'open', location: 'Sector 35', x: 42, y: 48, timeAgo: '2h ago' },
      { id: 'NS1102', title: 'Sukhna Lake path lights restored', category: 'Streetlight', status: 'resolved', location: 'Sukhna Lake', x: 60, y: 30, timeAgo: '1d ago' },
    ],
  },
};

// Fallback generator for ANY city entered manually
function generateCityData(cityName: string): CityInfo {
  return {
    name: cityName,
    state: 'India',
    tagline: 'Modern • Vibrant • Developing',
    temp: 27,
    weather: 'Pleasant & Sunny',
    image: 'https://images.unsplash.com/photo-1515162816999-a0c47dc192f7?w=800&auto=format&fit=crop&q=80',
    authorityName: `${cityName} Municipal Corporation`,
    stats: {
      total: 24,
      resolved: 17,
      avgHours: '< 30h',
      trendTotal: '↑ 10%',
      trendResolved: '↑ 22%',
      trendAvg: '↓ 14%',
    },
    popularIssues: [
      { category: 'Pothole / Road Damage', count: 32, percentage: 70, color: '#EF4444', iconType: 'pothole' },
      { category: 'Garbage / Waste', count: 24, percentage: 52, color: '#10B981', iconType: 'garbage' },
      { category: 'Streetlight', count: 18, percentage: 39, color: '#F59E0B', iconType: 'streetlight' },
      { category: 'Water Leakage', count: 12, percentage: 26, color: '#0284C7', iconType: 'water' },
      { category: 'Drainage', count: 9, percentage: 20, color: '#6366F1', iconType: 'drainage' },
      { category: 'Other Issues', count: 5, percentage: 11, color: '#A855F7', iconType: 'other' },
    ],
    recentUpdates: [
      { id: 'gen1', title: `Road resurfacing completed on Main Road in ${cityName}.`, timeAgo: '1 hour ago', status: 'Resolved', badgeColor: 'bg-emerald-50 text-emerald-600 border-emerald-100' },
      { id: 'gen2', title: `Sanitation team dispatched for waste clearance in ${cityName}.`, timeAgo: '3 hours ago', status: 'In Progress', badgeColor: 'bg-amber-50 text-amber-600 border-amber-100' },
      { id: 'gen3', title: `New smart LED streetlights fitted on Highway sector.`, timeAgo: '6 hours ago', status: 'Completed', badgeColor: 'bg-emerald-50 text-emerald-600 border-emerald-100' },
    ],
    mapCenter: [20.5937, 78.9629],
    mapIssues: [
      { id: 'NS001', title: `Pothole on Main Boulevard, ${cityName}`, category: 'Pothole', status: 'open', location: `Central Sector, ${cityName}`, x: 42, y: 40, timeAgo: '2h ago' },
      { id: 'NS002', title: `Waste collection required at Market Circle`, category: 'Garbage', status: 'open', location: `Market Square, ${cityName}`, x: 55, y: 62, timeAgo: '4h ago' },
      { id: 'NS003', title: `Streetlight maintenance completed`, category: 'Streetlight', status: 'resolved', location: `Station Road, ${cityName}`, x: 35, y: 70, timeAgo: '1d ago' },
    ],
  };
}

interface CityContextType {
  selectedCity: string;
  cityData: CityInfo;
  availableCities: string[];
  setSelectedCity: (city: string) => void;
  detectLocation: () => Promise<string | null>;
  isLocating: boolean;
  locationError: string | null;
  isCityModalOpen: boolean;
  setIsCityModalOpen: (open: boolean) => void;
}

const CityContext = createContext<CityContextType | undefined>(undefined);

export const CityProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  // Read saved city or default to New Delhi (national capital) if none set
  const [selectedCity, setSelectedCityState] = useState<string>(() => {
    return localStorage.getItem('nagarsetu_selected_city') || 'New Delhi';
  });
  const [isLocating, setIsLocating] = useState(false);
  const [locationError, setLocationError] = useState<string | null>(null);
  const [isCityModalOpen, setIsCityModalOpen] = useState(false);

  const availableCities = Object.keys(CITY_DATABASE);

  const setSelectedCity = (cityName: string) => {
    const trimmed = cityName.trim();
    if (!trimmed) return;
    setSelectedCityState(trimmed);
    localStorage.setItem('nagarsetu_selected_city', trimmed);
  };

  const detectLocation = async (): Promise<string | null> => {
    if (!('geolocation' in navigator)) {
      setLocationError('Geolocation not supported by this browser.');
      return null;
    }

    setIsLocating(true);
    setLocationError(null);

    return new Promise((resolve) => {
      navigator.geolocation.getCurrentPosition(
        async (position) => {
          try {
            const { latitude, longitude } = position.coords;
            // Reverse geocode with free OpenStreetMap Nominatim
            const res = await fetch(
              `https://nominatim.openstreetmap.org/reverse?format=json&lat=${latitude}&lon=${longitude}&zoom=10`
            );
            const data = await res.json();
            const detected =
              data.address?.city ||
              data.address?.town ||
              data.address?.state_district ||
              data.address?.county ||
              data.address?.state ||
              'New Delhi';

            // Check if detected city matches any in our database or use as-is
            const matched = availableCities.find(
              c => c.toLowerCase() === detected.toLowerCase() || detected.toLowerCase().includes(c.toLowerCase())
            ) || detected;

            setSelectedCity(matched);
            setIsLocating(false);
            resolve(matched);
          } catch {
            // If network fails during reverse geocode, fallback
            setIsLocating(false);
            resolve(selectedCity);
          }
        },
        (err) => {
          setIsLocating(false);
          setLocationError(err.message || 'Location permission denied.');
          resolve(null);
        },
        { timeout: 8000 }
      );
    });
  };

  const cityData: CityInfo =
    CITY_DATABASE[selectedCity] || generateCityData(selectedCity);

  return (
    <CityContext.Provider
      value={{
        selectedCity,
        cityData,
        availableCities,
        setSelectedCity,
        detectLocation,
        isLocating,
        locationError,
        isCityModalOpen,
        setIsCityModalOpen,
      }}
    >
      {children}
    </CityContext.Provider>
  );
};

export const useCity = (): CityContextType => {
  const context = useContext(CityContext);
  if (!context) {
    throw new Error('useCity must be used within a CityProvider');
  }
  return context;
};
