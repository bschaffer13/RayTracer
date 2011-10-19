/*
 * Vector.tpp
 *
 *  Created on: Aug 27, 2010
 *      Author: norton
 */

#ifndef VECTOR_TPP_INCLUDE
#define VECTOR_TPP_INCLUDE

#include <iostream>
#include <cstring>
#include <cmath>

#define V_SIZE 4

namespace ray {

  class vector {
    public:

      typedef       double*       iterator;
      typedef const double* const_iterator;

      vector(double d = 0);
      vector(double x, double y, double z);
      vector(double* d) : data(d), del(false) { }
      vector(const vector& cpy);
      ~vector();

      const vector& operator=(const vector& asn);

      /* ********** getters and setters ********** */
      inline double& operator[](int i)       { return data[i]; }
      inline double  operator[](int i) const { return data[i]; }
      inline int     size()            const { return V_SIZE;  }
      inline void    clear() { std::memset(data, 0, V_SIZE * sizeof(double)); }
      inline double* ptr() const { return data; }
      inline bool    own() const { return del;  }

      inline       iterator begin()       { return data;          }
      inline       iterator end()         { return data + V_SIZE; }
      inline const_iterator begin() const { return data;          }
      inline const_iterator end()   const { return data + V_SIZE; }

      /* ********** Math Operators ********** */
      vector cross(const vector& rhs) const;
      vector normal() const;
      double distance(const vector& rhs) const;
      double dot(const vector& rhs) const;
      double length() const;
      void negate();
      void normalize(bool to_w = false);
      vector& operator+=(const vector& v);
      vector& operator+=(const double& d);
      vector& operator/=(const double& d);

      vector  operator*(const vector& rhs) const;
      vector  operator*(double d)          const;

    protected:
      double* data;
      int     del;
  };
}

bool operator==(const ray::vector& lhs, const ray::vector& rhs);
bool operator!=(const ray::vector& lhs, const ray::vector& rhs);

ray::vector operator-(const ray::vector& lhs, const ray::vector& rhs);
ray::vector operator+(const ray::vector& lhs, const ray::vector& rhs);

std::ostream& operator<<(std::ostream& ostr, const ray::vector& v);

#endif /* VECTOR_TPP_INCLUDE */
